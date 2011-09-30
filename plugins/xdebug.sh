#!/bin/bash

# PHP.next Development releases depend on current XDebug development
# snapshots.
function install_xdebug_master {
    local source_dir="$PHP_BUILD_ROOT/source/xdebug-master"
    local cwd=$(pwd)

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "XDebug" "Updating XDebug from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd -
    else
        log "XDebug" "Fetching from Git Master"
        git clone git://github.com/derickr/xdebug.git "$source_dir" > /dev/null
    fi

    _build_xdebug "$source_dir"

    cd "$source_dir"
    git reset --hard HEAD > /dev/null
    cd "$cwd"
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
    if [ ! -f "$PHP_BUILD_ROOT/packages/xdebug-$version.tgz" ]; then
        wget -qP "$PHP_BUILD_ROOT/packages" "$package_url"
    fi

    # Each tarball gets extracted to `source/xdebug-$version`.
    if [ -d "$PHP_BUILD_ROOT/source/xdebug-$version" ]; then
        rm "$PHP_BUILD_ROOT/source/xdebug-$version" -rf
    fi

    tar -xzf "$PHP_BUILD_ROOT/packages/xdebug-$version.tgz" -C "$PHP_BUILD_ROOT/source"

    [[ -f "$PHP_BUILD_ROOT/source/package.xml" ]] && rm "$PHP_BUILD_ROOT/source/package.xml"
    [[ -f "$PHP_BUILD_ROOT/source/package2.xml" ]] && rm "$PHP_BUILD_ROOT/source/package2.xml"

    _build_xdebug "$PHP_BUILD_ROOT/source/xdebug-$version"
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
    local extension_dir=$(echo "<?php echo ini_get('extension_dir');" | "$PREFIX/bin/php")

    if [ ! -f "$xdebug_ini" ]; then
        log "XDebug" "Installing XDebug configuration in $xdebug_ini"

        echo "zend_extension=\"$extension_dir/xdebug.so\"" > $xdebug_ini
        echo "html_errors=on" >> $xdebug_ini
    fi

    cd "$cwd"

    echo "Done."
}
