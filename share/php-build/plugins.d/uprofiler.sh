#!/usr/bin/env bash

function install_uprofiler_master {
    local source_dir="$TMP/source/uprofiler-master"
    local cwd=$(pwd)
    local revision=$1

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "uprofiler" "Updating uprofiler from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "uprofiler" "Fetching from Git Master"
        git clone https://github.com/FriendsOfPHP/uprofiler.git "$source_dir" > /dev/null
    fi

    if [ -n "$revision" ]; then
        log "uprofiler" "Checkout specified revision: $revision"
        cd "$source_dir"
        git reset --hard $revision
        cd "$cwd"
    fi

    _build_uprofiler "$source_dir"
}

function _build_uprofiler {
    local source_dir="$1"
    local cwd=$(pwd)

    log "uprofiler" "Compiling in $source_dir"

    cd "$source_dir/extension"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local uprofiler_home="$PREFIX/share/uprofiler"

    [ ! -d "$uprofiler_home" ] && mkdir -p "$uprofiler_home"

    # copy uprofiler_html & uprofiler_lib
    cp -r "$source_dir/uprofiler_html" "$uprofiler_home"
    cp -r "$source_dir/uprofiler_lib" "$uprofiler_home"

    local uprofiler_ini="$PREFIX/etc/conf.d/uprofiler.ini"

    local extension_dir=$("$PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    if [ ! -f "$uprofiler_ini" ]; then
        log "uprofiler" "Installing uprofiler configuration in $uprofiler_ini"

        echo "extension=\"$extension_dir/uprofiler.so\"" > $uprofiler_ini
        echo "uprofiler.output_dir=\"/var/tmp/uprofiler\"" >> $uprofiler_ini

    fi

    log "uprofiler" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
