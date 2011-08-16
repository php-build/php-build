#!/bin/bash

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
    git reset --hard HEAD
    cd -
}

function install_xdebug {
    local version=$1

    if [ -z "$version" ]; then
        return 1
    fi

    if [ ! -f "$PHP_BUILD_ROOT/packages/xdebug-$version.tgz" ]; then
        wget -qP "$PHP_BUILD_ROOT/packages" "http://xdebug.org/files/xdebug-$version.tgz"
    fi

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

    local old_pwd=$(pwd)

    cd "$source_dir"

    local php_version=$(echo "<?php echo PHP_VERSION;" | "$PREFIX/bin/php")

    $PREFIX/bin/phpize > /dev/null
    "$(pwd)/configure" --enable-xdebug --with-php-config=$PREFIX/bin/php-config > /dev/null

    make > /dev/null
    make install > /dev/null

    local xdebug_ini="$PREFIX/etc/conf.d/xdebug.ini"

    # Somehow xdebug needs the absolute path to the extensions directory
    # to get loaded, so get it from the PHP binary
    local extension_dir=$(echo "<?php echo ini_get('extension_dir');" | "$PREFIX/bin/php")

    if [ ! -f "$xdebug_ini" ]; then
        echo "Installing xdebug.ini"
        echo "zend_extension=\"$extension_dir/xdebug.so\"" > $xdebug_ini
        echo "html_errors=on" >> $xdebug_ini
    fi

    cd "$old_pwd"

    echo "Done."
}
