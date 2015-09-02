#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.
#
# Plugin for php-build to install PHP extensions
#

function install_extension {
    local extension="$1"
    local version="$2"
    local type="$3"
    local database=$PHP_BUILD_ROOT/share/php-build/extension/definition

    # set type to "dist" per default
    [[ -z "$type" ]] && type="dist"

    local extension_line=$(grep "\"$extension\"" $database)

    if [ -n "$extension_line" ]; then
        IFS=, read name url_dist url_source source_cwd configure_args \
            extension_type after_install <<< "$(echo "$extension_line" | sed 's/\"//g')"

        # install from distribution package
        if [ $type = "dist" ]; then
            log "$extension" "Installing version $version"

            if [ -z "$version" ]; then
                echo "No version given for extension \"$extension\"" >&3
                return 1
            fi

            _download_extension $name $version $url_dist "$configure_args" \
                $extension_type "$after_install"
        else
            log "$extension" "Installing from source"

            _checkout_extension $name "$version" $url_source "$source_cwd" \
                "$configure_args" $extension_type "$after_install"
        fi
    else
        echo "No configuration found fo extension \"$extension\", skipping" >&3
    fi
}

function install_extension_source {
    local extension="$1"
    local revision="$2"

    install_extension $extension "$revision" "source"
}

function _download_extension {
    local name=$1
    local version=$2
    local url=$3
    local configure_args=$4
    local extension_type=$5
    local after_install=$6
    local package_url=$(eval echo $url)
    local package_name="$name-$version"

     # We cache the tarballs for APC versions in `packages/`.
    if [ ! -f "$TMP/packages/$name-$version.tgz" ]; then
        http get "$package_url" > "$TMP/packages/$package_name.tgz"
    fi

    # Each tarball gets extracted to `source/apcu-$version`.
    if [ -d "$TMP/source/$package_name" ]; then
        rm -rf "$TMP/source/$package_name"
    fi

    tar -xzf "$TMP/packages/$package_name.tgz" -C "$TMP/source"

    [[ -f "$TMP/source/package.xml" ]] && rm "$TMP/source/package.xml"
    [[ -f "$TMP/source/package2.xml" ]] && rm "$TMP/source/package2.xml"

    _build_extension "$TMP/source/$package_name" $name "" "$configure_args" \
        $extension_type "$after_install"
}

function _checkout_extension {
    local name=$1
    local version="$2"
    local url_source="$3"
    local source_cwd="$4"
    local configure_args="$5"
    local extension_type="$6"
    local after_install="$7"
    local source_dir="$TMP/source/$name-master"

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "$name" "Updating $name from Git Master"
        cd "$source_dir"
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "$name" "Fetching from Git Master"
        git clone "$url_source" "$source_dir" > /dev/null
    fi

    if [ -n "$version" ]; then
        log "$name" "Checkout specified revision: $version"
        cd "$source_dir"
        git reset --hard $revision
        cd "$cwd"
    fi

    _build_extension "$source_dir" $name "$source_cwd" "$configure_args" \
        $extension_type "$after_install"
}

function _build_extension {
    local source_dir="$1"
    local name=$2
    local source_cwd="$3"
    local configure_args=$4
    local extension_type=$5
    local after_install=$6
    local cwd=$(pwd)

    log "$name" "Compiling $name in $source_dir"

    cd "$source_dir/$source_cwd"

    {
        $PREFIX/bin/phpize > /dev/null
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config \
            $configure_args > /dev/null

        make > /dev/null
        make install > /dev/null
    } >&4 2>&1

    local extension_home="$PREFIX/share/$name"

    [ ! -d "$extension_home" ] && mkdir -p "$extension_home"

    local extension_ini="$PREFIX/etc/conf.d/$name.ini"

    if [ ! -f "$extension_ini" ]; then
        log "$name" "Installing $name configuration in $extension_ini"

        echo "$extension_type=\"$name.so\"" > $extension_ini
    fi

    if [ -n "$after_install" ]; then
        # Zend extensions are not looked up in PHP's extension dir, so
        # we need to find the absolute path for the extension_dir.
        local extension_dir=$("$PREFIX/bin/php-config" --extension-dir)

        $after_install "$source_dir" "$extension_ini" "$extension_type" "$extension_dir" "$extension_home"
    fi

    log "$name" "Cleaning up."
    make clean > /dev/null

    cd "$cwd" > /dev/null
}
