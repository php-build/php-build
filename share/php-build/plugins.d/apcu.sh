#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_apcu {
    local version=$1
    local package_url="http://pecl.php.net/get/apcu-$version.tgz"

    if [ -z "$version" ]; then
        echo "install_apcu: No Version given." >&3
        return 1
    fi

    log "APCu" "Downloading $package_url"

    # We cache the tarballs for APC versions in `packages/`.
    if [ ! -f "$TMP/packages/apcu-$version.tgz" ]; then
        http get "$package_url" > "$TMP/packages/apcu-$version.tgz"
    fi

    # Each tarball gets extracted to `source/apcu-$version`.
    if [ -d "$TMP/source/apcu-$version" ]; then
        rm -rf "$TMP/source/apcu-$version"
    fi

    tar -xzf "$TMP/packages/apcu-$version.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_apcu "$TMP/source/apcu-$version"
}

function _build_apcu {
    local source_dir="$1"
    local cwd=$(pwd)

    log "APCu" "Compiling in $source_dir"

    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local apcu_home="$PREFIX/share/apcu"

    [ ! -d "$apcu_home" ] && mkdir -p "$apcu_home"

    local apcu_ini="$PREFIX/etc/conf.d/apcu.ini"

    if [ ! -f "$apcu_ini" ]; then
        log "APCu" "Installing APCu configuration in $apcu_ini"

        echo "extension=\"apcu.so\"" > $apcu_ini

    fi

    log "APCu" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
