#!/bin/bash

function install_pyrus {
    echo -n "Installing Pyrus..."

    local pyrus_url="http://pear2.php.net/pyrus.phar"

    if [ -f "$PREFIX/bin/pyrus.phar" ]; then
        rm "$PREFIX/bin/pyrus.phar"
    fi

    if [ ! -f "$PHP_BUILD_ROOT/packages/pyrus.phar" ]; then
        wget -qP "$PHP_BUILD_ROOT/packages" $pyrus_url
    fi

    cp "$PHP_BUILD_ROOT/packages/pyrus.phar" "$PREFIX/bin/pyrus.phar"

    if [ ! -d "$PREFIX/pear" ]; then
        mkdir "$PREFIX/pear"
    fi

    # Store Pyrus' config in `share/pear`.
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
    # Pyrus looks for its config by default in the User's Home Directory,
    # so define a separate Home Directory just for Pyrus to isolate
    # the Configs between PHP versions
    cat > "$PREFIX/bin/pyrus" <<SH
#!/usr/bin/env bash
export HOME="$pyrus_home"
"$PREFIX/bin/php" -dphar.readonly=0 "$PREFIX/bin/pyrus.phar" \$@
SH

    chmod +x "$PREFIX/bin/pyrus"

    # Setup Pyrus to place executables in the version's `bin` directory
    # so that one can simply add the version's `bin` directory to the
    # `PATH`.
    cat > "$PREFIX/pear/.config" <<EOF
<?xml version="1.0"?>
<pearconfig version="1.0">
    <bin_dir>$PREFIX/bin</bin_dir>
</pearconfig>
EOF

    if [ ! -d "$pyrus_home/.pear" ]; then
        mkdir "$pyrus_home/.pear"
    fi

    # Create the default pearconfig.xml by hand, otherwise the
    # User would be asked for the PEAR path on the first run.
    cat > "$pyrus_home/.pear/pearconfig.xml" <<EOF
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

    echo " Done."
}
