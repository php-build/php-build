#!/bin/bash

download_pyrus() {
    local pyrus_url="$1"

    if [ -z "$pyrus_url" ]; then
        pyrus_url="http://pear2.php.net/pyrus.phar"
    fi

    log "Pyrus" "Downloading from $pyrus_url"

    if [ ! -f "$TMP/packages/pyrus.phar" ]; then
        wget -qP "$TMP/packages" $pyrus_url
    fi
}

copy_pyrus_phar() {
    cp "$TMP/packages/pyrus.phar" "$PREFIX/bin/pyrus.phar"
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

    "$PREFIX/bin/pyrus" set bin_dir "$PREFIX/bin/" &> /dev/null
    "$PREFIX/bin/pyrus" set php_prefix "$PREFIX/bin/" &> /dev/null
}
