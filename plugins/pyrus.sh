#!/bin/bash

function install_pyrus {
    echo "Installing Pyrus..."

    local pyrus_url="http://pear2.php.net/pyrus.phar"

    if [ -f "$PREFIX/bin/pyrus.phar" ]; then
        rm "$PREFIX/bin/pyrus.phar"
    fi

    if [ ! -f "$PHP_BUILD_ROOT/tmp/pyrus.phar" ]; then
        wget -qP "$PHP_BUILD_ROOT/tmp" $pyrus_url
    fi

    cp "$PHP_BUILD_ROOT/tmp/pyrus.phar" "$PREFIX/bin/pyrus.phar"

    if [ ! -d "$PREFIX/pear" ]; then
        mkdir "$PREFIX/pear"
    fi

    local pyrus_home="$PREFIX/share/pear"

    # Create Pyrus' own Home Directory
    # so it will not place them in the real user's home directory
    if [ ! -d "$pyrus_home" ]; then
        mkdir -p "$pyrus_home"
    fi

    # Add the directory where the PHP Files of PEAR Packages get installed
    # to PHP's include path
    echo "include_path=.:$PREFIX/pear/php" > "$PREFIX/etc/conf.d/pear.ini"

    # Create the Pyrus executable
    #
    local pyrus_sh="$PREFIX/bin/pyrus"

    echo "#!/bin/bash" > $pyrus_sh

    # Pyrus looks for its config by default in the User's Home Directory,
    # so define a separate Home Directory just for Pyrus to isolate
    # the Configs between PHP versions
    echo "export HOME=$pyrus_home" >> $pyrus_sh
    echo "$PREFIX/bin/php -dphar.readonly=0 $PREFIX/bin/pyrus.phar \$*" >> $pyrus_sh

    chmod +x "$PREFIX/bin/pyrus"

    # Setup Pyrus to place executables in the version's bin directory
    # so executables can be later easier collected on rehash
    local pear_sysconfig=$(cat <<EOF
<?xml version="1.0"?>
<pearconfig version="1.0">
    <bin_dir>$PREFIX/bin</bin_dir>
</pearconfig>
EOF
)

    echo "$pear_sysconfig" > "$PREFIX/pear/.config"

    # Create the default pearconfig.xml by hand, otherwise the
    # User would be asked for the PEAR path on the first run.
    local pear_config=$(cat <<EOF
<?xml version="1.0"?>
<pearconfig version="1.0">
    <default_channel>pear2.php.net</default_channel>
    <auto_discover>0</auto_discover>
    <http_proxy></http_proxy>
    <cache_dir>$PREFIX/pear/cache</cache_dir>
    <temp_dir>$PREFIX/pear/temp</temp_dir>
    <verbose>1</verbose>
    <preferred_state>stable</preferred_state>
    <umask>0022</umask>
    <cache_ttl>3600</cache_ttl>
    <my_pear_path>$PREFIX/pear</my_pear_path>
    <plugins_dir>$PREFIX/share/pear/.pear</plugins_dir>
</pearconfig>
EOF
)

    if [ ! -d "$pyrus_home/.pear" ]; then
        mkdir "$pyrus_home/.pear"
    fi

    echo $pear_config > "$pyrus_home/.pear/pearconfig.xml"

    echo Done.
}
