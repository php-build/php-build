#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_imagick {
    local version=$1
    local package_url="http://pecl.php.net/get/imagick-$version.tgz"

    if [ -z "$version" ]; then
        echo "install_imagick: No Version given." >&3
        return 1
    fi

    log "Imagick" "Downloading $package_url"

    # We cache the tarballs for Imagick versions in `packages/`.
    if [ ! -f "$TMP/packages/imagick-$version.tgz" ]; then
        http get "$package_url" > "$TMP/packages/imagick-$version.tgz"
    fi

    # Each tarball gets extracted to `source/imagick-$version`.
    if [ -d "$TMP/source/imagick-$version" ]; then
        rm -rf "$TMP/source/imagick-$version"
    fi

    tar -xzf "$TMP/packages/imagick-$version.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_imagick "$TMP/source/imagick-$version"
}

function _build_imagick {
    local source_dir="$1"
    local cwd=$(pwd)

    log "Imagick" "Compiling in $source_dir"
    cd "$source_dir"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local imagick_home="$PREFIX/share/imagick"

    [ ! -d "$imagick_home" ] && mkdir -p "$imagick_home"

    local imagick_ini="$PREFIX/etc/conf.d/imagick.ini"

    if [ ! -f "$imagick_ini" ]; then
        log "Imagick" "Installing APC configuration in $imagick_ini"
        echo "extension=\"imagick.so\"" > $imagick_ini
    fi

    log "Imagick" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
