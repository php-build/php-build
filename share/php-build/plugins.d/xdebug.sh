#!/usr/bin/env bash

# PHP.next Development releases depend on current XDebug development
# snapshots.
function install_xdebug_master {
    local source_dir="$TMP/source/xdebug-master"
    local cwd=$(pwd)
    local revision=$1

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "XDebug" "Updating XDebug from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "XDebug" "Fetching from Git Master"
        git clone git://github.com/derickr/xdebug.git "$source_dir" > /dev/null
    fi

    if [ -n "$revision" ]; then
        log "XDebug" "Checkout specified revision: $revision"
        cd "$source_dir"
        git reset --hard $revision
        cd "$cwd"
    fi

    _build_xdebug "$source_dir"
}

# On the contrary, for stable PHP versions we need a stable XDebug version
function install_xdebug {
    local version=$1
    local package_url="http://xdebug.org/files/xdebug-$version.tgz"

    if [ -z "$version" ]; then
        echo "install_xdebug: No Version given." >&3
        return 1
    fi

    log "XDebug" "Downloading $package_url"

    # We cache the tarballs for XDebug versions in `packages/`.
    if [ ! -f "$TMP/packages/xdebug-$version.tgz" ]; then
        wget -qP "$TMP/packages" "$package_url"
    fi

    # Each tarball gets extracted to `source/xdebug-$version`.
    if [ -d "$TMP/source/xdebug-$version" ]; then
        rm -rf "$TMP/source/xdebug-$version"
    fi

    tar -xzf "$TMP/packages/xdebug-$version.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_xdebug "$TMP/source/xdebug-$version"
}

function _build_xdebug {
    local source_dir="$1"
    local cwd=$(pwd)

    log "XDebug" "Compiling in $source_dir"

    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --enable-xdebug \
        --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local xdebug_ini="$PREFIX/etc/conf.d/xdebug.ini"

    # Zend extensions are not looked up in PHP's extension dir, so
    # we need to find the absolute path for the extension_dir.
    local extension_dir=$("$PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    if [ -z "$PHP_BUILD_XDEBUG_ENABLE" ]; then
        PHP_BUILD_XDEBUG_ENABLE=yes
    fi

    if [ ! -f "$xdebug_ini" ]; then
        log "XDebug" "Installing XDebug configuration in $xdebug_ini"

        # Comment out the lines in the xdebug.ini when the env variable
        # is set to something to "no"
        local conf_line_prefix=
        if [ "$PHP_BUILD_XDEBUG_ENABLE" == "off" ]; then
            log "XDebug" "XDebug is commented out in $xdebug_ini. Remove the \";\" to enable it."
            conf_line_prefix=";"
        fi

        echo "$conf_line_prefix zend_extension=\"$extension_dir/xdebug.so\"" > $xdebug_ini
        echo "$conf_line_prefix html_errors=on" >> $xdebug_ini
    fi

    log XDebug "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
