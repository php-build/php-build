#!/bin/bash

function install_xdebug_master {
    local TEMP_DIR="$PHP_BUILD_ROOT/tmp"

    if [ -d "$TEMP_DIR/xdebug-master" ] && [ -d "$TEMP_DIR/xdebug-master/.git" ]; then
        local old_pwd=$(pwd)

        echo "Updating XDebug from master"

        cd "$TEMP_DIR/xdebug-master"
        git pull origin master > /dev/null
        cd "$old_pwd"
    else
        echo "Fetching XDebug from master"
        git clone git://github.com/derickr/xdebug.git "$TEMP_DIR/xdebug-master" > /dev/null
    fi

    _build_xdebug "$TEMP_DIR/xdebug-master"

    git --git-dir="$TEMP_DIR/xdebug-master/.git" reset --hard HEAD
}

function install_xdebug {
    local version=$1

    if [ -z "$version" ]; then
        return 1
    fi

    if [ ! -f "$PHP_BUILD_ROOT/tmp/xdebug-$version.tgz" ]; then
        wget -qP "$PHP_BUILD_ROOT/tmp" "http://xdebug.org/files/xdebug-$version.tgz"
    fi

    if [ -d "$PHP_BUILD_ROOT/tmp/xdebug-$version" ]; then
        rm "$PHP_BUILD_ROOT/tmp/xdebug-$version" -rf
    fi

    tar -xzf "$PHP_BUILD_ROOT/tmp/xdebug-$version.tgz" -C "$PHP_BUILD_ROOT/tmp"

    _build_xdebug "$PHP_BUILD_ROOT/tmp/xdebug-$version"
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
