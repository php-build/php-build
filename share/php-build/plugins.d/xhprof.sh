#!/usr/bin/env bash

function install_xhprof_master {
    local source_dir="$TMP/source/xhprof-master"
    local cwd=$(pwd)
    local revision=$1

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "xhprof" "Updating xhprof from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "xhprof" "Fetching from Git Master"
        git clone git://github.com/facebook/xhprof.git "$source_dir" > /dev/null
    fi

    if [ -n "$revision" ]; then
        log "xhprof" "Checkout specified revision: $revision"
        cd "$source_dir"
        git reset --hard $revision
        cd "$cwd"
    fi

    _build_xhprof "$source_dir"
}

function install_xhprof {
    local version=$1
    local package_url="http://pecl.php.net/get/xhprof-$version.tgz"

    if [ -z "$version" ]; then
        echo "install_xhprof: No Version given." >&3
        return 1
    fi

    log "xhprof" "Downloading $package_url"

    # We cache the tarballs for xhprof versions in `packages/`.
    if [ ! -f "$TMP/packages/xhprof-$version.tgz" ]; then
        wget -qP "$TMP/packages" "$package_url"
    fi

    # Each tarball gets extracted to `source/xhprof-$version`.
    if [ -d "$TMP/source/xhprof-$version" ]; then
        rm -rf "$TMP/source/xhprof-$version"
    fi

    tar -xzf "$TMP/packages/xhprof-$version.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_xhprof "$TMP/source/xhprof-$version"
}

function _build_xhprof {
    local source_dir="$1"
    local cwd=$(pwd)

    log "xhprof" "Compiling in $source_dir"

    cd "$source_dir/extension"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local xhprof_home="$PREFIX/share/xhprof"

    [ ! -d "$xhprof_home" ] && mkdir -p "$xhprof_home"

    # copy xhprof_html & xhprof_lib
    cp -r "$source_dir/xhprof_html" "$xhprof_home"
    cp -r "$source_dir/xhprof_lib" "$xhprof_home"

    local xhprof_ini="$PREFIX/etc/conf.d/xhprof.ini"

    local extension_dir=$("$PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    if [ ! -f "$xhprof_ini" ]; then
        log "xhprof" "Installing xhprof configuration in $xhprof_ini"

        echo "extension=\"$extension_dir/xhprof.so\"" > $xhprof_ini
        echo "xhprof.output_dir=\"/var/tmp/xhprof\"" >> $xhprof_ini

    fi

    log "xhprof" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}

