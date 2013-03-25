#!/usr/bin/env bash

function install_apc {
    local version=$1
    local package_url="http://pecl.php.net/get/APC-$version.tgz"

    if [ -z "$version" ]; then
        echo "install_APC: No Version given." >&3
        return 1
    fi

    log "APC" "Downloading $package_url"

    # We cache the tarballs for APC versions in `packages/`.
    if [ ! -f "$TMP/packages/APC-$version.tgz" ]; then
        wget -qP "$TMP/packages" "$package_url"
    fi

    # Each tarball gets extracted to `source/APC-$version`.
    if [ -d "$TMP/source/APC-$version" ]; then
        rm -rf "$TMP/source/APC-$version"
    fi

    tar -xzf "$TMP/packages/APC-$version.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_apc "$TMP/source/APC-$version"
}

function _build_apc {
    local source_dir="$1"
    local cwd=$(pwd)

    log "APC" "Compiling in $source_dir"

    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --enable-apc \
        --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local apc_home="$PREFIX/share/apc"

    [ ! -d "$apc_home" ] && mkdir -p "$apc_home"

    local apc_ini="$PREFIX/etc/conf.d/apc.ini"

    if [ ! -f "$apc_ini" ]; then
        log "APC" "Installing APC configuration in $apc_ini"

        echo "extension=\"apc.so\"" > $apc_ini

    fi

    log "APC" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}

