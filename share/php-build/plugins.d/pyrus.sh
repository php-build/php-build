#!/usr/bin/env bash

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

    if [ ! -d "$PREFIX/pyrus" ]; then
        mkdir "$PREFIX/pyrus"
    fi

    local pyrus_home="$PREFIX/share/pyrus"

    [ ! -d "$pyrus_home" ] && mkdir -p "$pyrus_home"

    # Add the directory where the PHP Files of PEAR Packages get installed
    # to PHP's include path

    local default_include_path=$("$PREFIX/bin/php" -r "echo get_include_path();")
    echo "include_path=$default_include_path:$PREFIX/share/pyrus/.pear/php" > "$PREFIX/etc/conf.d/pyrus.ini"

    log "Pyrus" "Installing executable in $PREFIX/bin/pyrus"

    # Create the Pyrus executable
    cat > "$PREFIX/bin/pyrus" <<SH
#!/usr/bin/env bash
export HOME="$pyrus_home"
"$PREFIX/bin/php" -dphar.readonly=0 "$PREFIX/bin/pyrus.phar" \$@
SH

    chmod +x "$PREFIX/bin/pyrus"

    if [ ! -f "$pyrus_home/.pear/pearconfig.xml" ]; then
        [ ! -d "$pyrus_home/.pear" ] && mkdir "$pyrus_home/.pear"

        # Create the default pearconfig.xml by hand, otherwise the
        # User would be asked for the PEAR path on the first run.
        cat > "$pyrus_home/.pear/pearconfig.xml" <<EOF
<?xml version="1.0"?>
<pearconfig version="1.0">
    <default_channel>pear2.php.net</default_channel>
    <auto_discover>0</auto_discover>
    <http_proxy></http_proxy>
    <cache_dir>$pyrus_home/.pear/cache</cache_dir>
    <temp_dir>$pyrus_home/.pear/tmp</temp_dir>
    <verbose>1</verbose>
    <preferred_state>stable</preferred_state>
    <umask>0022</umask>
    <cache_ttl>3600</cache_ttl>
    <my_pear_path>$pyrus_home/.pear</my_pear_path>
    <plugins_dir>$pyrus_home/.pear</plugins_dir>
</pearconfig>
EOF
    fi

    local ext_dir=$("$PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    "$PREFIX/bin/pyrus" set bin_dir "$PREFIX/bin/" &> /dev/null
    "$PREFIX/bin/pyrus" set php_prefix "$PREFIX/bin/" &> /dev/null
    "$PREFIX/bin/pyrus" set ext_dir "$ext_dir" &> /dev/null
}
