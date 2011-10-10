#!/bin/bash

download_pyrus() {
    local pyrus_url="$1"

    if [ -z "$pyrus_url" ]; then
        pyrus_url="http://pear2.php.net/pyrus.phar"
    fi

    log "Pyrus" "Downloading from $pyrus_url"

    if [ ! -f "$PHP_BUILD_ROOT/packages/pyrus.phar" ]; then
        wget -qP "$PHP_BUILD_ROOT/packages" $pyrus_url
    fi
}

copy_pyrus_phar() {
    cp "$PHP_BUILD_ROOT/packages/pyrus.phar" "$PREFIX/bin/pyrus.phar"
}

install_pyrus() {
    download_pyrus
    copy_pyrus_phar

    if [ ! -d "$PREFIX/pear" ]; then
        mkdir "$PREFIX/pear"
    fi

    # Add the directory where the PHP Files of PEAR Packages get installed
    # to PHP's include path
    echo "include_path=.:$PREFIX/pear/php" > "$PREFIX/etc/conf.d/pear.ini"

    log "Pyrus" "Installing executable in $PREFIX/bin/pyrus"

    # Create the Pyrus executable
    #
    # Pyrus looks for its config by default in the User's Home Directory,
    # so define a separate Home Directory just for Pyrus to isolate
    # the Configs between PHP versions
    cat > "$PREFIX/bin/pyrus" <<SH
#!/usr/bin/env bash
"$PREFIX/bin/php" -dphar.readonly=0 "$PREFIX/bin/pyrus.phar" "$PREFIX/pear" \$@
SH

    chmod +x "$PREFIX/bin/pyrus"

    if [ ! -f "$HOME/.pear/pearconfig.xml" ]; then
        [ ! -d "$HOME/.pear" ] && mkdir "$HOME/.pear"

        # Create the default pearconfig.xml by hand, otherwise the
        # User would be asked for the PEAR path on the first run.
        cat > "$HOME/.pear/pearconfig.xml" <<EOF
<?xml version="1.0"?>
<pearconfig version="1.0">
    <default_channel>pear2.php.net</default_channel>
    <auto_discover>0</auto_discover>
    <http_proxy></http_proxy>
    <cache_dir>$HOME/.pear/cache</cache_dir>
    <temp_dir>$HOME/.pear/tmp</temp_dir>
    <verbose>1</verbose>
    <preferred_state>stable</preferred_state>
    <umask>0022</umask>
    <cache_ttl>3600</cache_ttl>
    <my_pear_path>$HOME/.pear</my_pear_path>
    <plugins_dir>$HOME/.pear</plugins_dir>
</pearconfig>
EOF
    fi

    "$PREFIX/bin/pyrus" set bin_dir "$PREFIX/bin" &> /dev/null
}
