#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_xcache {
    local version=$1
    local package_url="http://xcache.lighttpd.net/pub/Releases/$version/xcache-$version.tar.gz"

    if [ -z "$version" ]; then
        echo "install_xcache: No Version given." >&3
        return 1
    fi

    log "Xcache" "Downloading $package_url"

    # We cache the tarballs for Xcache versions in `packages/`.
    if [ ! -f "$TMP/packages/xcache-$version.tar.gz" ]; then
        http get "$package_url" > "$TMP/packages/xcache-$version.tar.gz"
    fi

    # Each tarball gets extracted to `source/xcache-$version`.
    if [ -d "$TMP/source/xcache-$version" ]; then
        rm -rf "$TMP/source/xcache-$version"
    fi

    tar -xzf "$TMP/packages/xcache-$version.tar.gz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_xcache "$TMP/source/xcache-$version"
}

function _build_xcache {
    local source_dir="$1"
    local cwd=$(pwd)

    log "Xcache" "Compiling in $source_dir"
    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --enable-xcache \
            --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local xcache_home="$PREFIX/share/xcache"

    [ ! -d "$xcache_home" ] && mkdir -p "$xcache_home"

    local xcache_ini="$PREFIX/etc/conf.d/xcache.ini"

    if [ ! -f "$xcache_ini" ]; then
        log "Xcache" "Installing Xcache configuration in $xcache_ini"
        echo "extension=\"xcache.so\"" > $xcache_ini
    fi

    log "Xcache" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
