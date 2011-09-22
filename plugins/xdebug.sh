#!/bin/bash

# PHP.next Development releases depend on current XDebug development
# snapshots.
function install_xdebug_master {
    local source_dir="$PHP_BUILD_ROOT/source/xdebug-master"

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        echo "Updating XDebug from master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd -
    else
        echo "Fetching XDebug from master"
        git clone git://github.com/derickr/xdebug.git "$source_dir" > /dev/null
    fi

    _build_xdebug "$source_dir"

    cd "$source_dir"
    git reset --hard HEAD > /dev/null
    cd - > /dev/null
}

# On the contrary, for stable PHP versions we need a stable XDebug version
function install_xdebug {
    local version=$1

    if [ -z "$version" ]; then
        echo "install_xdebug: No Version given." >&3
        return 1
    fi

    # We cache the tarballs for XDebug versions in `packages/`.
    if [ ! -f "$PHP_BUILD_ROOT/packages/xdebug-$version.tgz" ]; then
        wget -qP "$PHP_BUILD_ROOT/packages" "http://xdebug.org/files/xdebug-$version.tgz"
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

    echo "Installing the XDebug Extension..."

    local cwd=$(pwd)

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
        echo "Installing xdebug.ini"
        echo "zend_extension=\"$extension_dir/xdebug.so\"" > $xdebug_ini
        echo "html_errors=on" >> $xdebug_ini
    fi

    cd "$cwd"

    echo "Done."
}
