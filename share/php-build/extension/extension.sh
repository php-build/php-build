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
        echo "No configuration found for extension \"$extension\", skipping" >&3
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
    local basename=$(eval basename $url)
    local source_dir=$(eval basename ${url%.*})
    local temp_package="$PHP_BUILD_TMPDIR/$basename"
    local package_file="$PHP_BUILD_TMPDIR/packages/$basename"

    # Remove the temp file if one exists.
    if [ -f "$temp_package" ]; then
        rm "$temp_package"
    fi

    # Do not download a package when it's already downloaded.
    if [ -f "$package_file" ]; then
        log "Skipping" "Already downloaded $package_url"
    else
        log "Downloading" "$package_url"
        http get "$package_url" > "$temp_package"
        cp "$temp_package" "$PHP_BUILD_TMPDIR/packages"
        rm "$temp_package"
    fi

    # Each tarball gets extracted to `source/$name-$version`.
    if [ -d "$PHP_BUILD_TMPDIR/source/$package_name" ]; then
        rm -rf "$PHP_BUILD_TMPDIR/source/$package_name"
    fi

    tar -xzf "$PHP_BUILD_TMPDIR/packages/$package_name.tgz" -C "$PHP_BUILD_TMPDIR/source"

    # change the directory name for APC since it expands with an uppercase filename
    if [[ ! -d $PHP_BUILD_TMPDIR/source/$package_name && -d $PHP_BUILD_TMPDIR/source/$source_dir ]]; then
      mv $PHP_BUILD_TMPDIR/source/$source_dir $PHP_BUILD_TMPDIR/source/$package_name
    fi

    [[ -f "$PHP_BUILD_TMPDIR/source/package.xml" ]] && rm "$PHP_BUILD_TMPDIR/source/package.xml"
    [[ -f "$PHP_BUILD_TMPDIR/source/package2.xml" ]] && rm "$PHP_BUILD_TMPDIR/source/package2.xml"

    _build_extension "$PHP_BUILD_TMPDIR/source/$package_name" $name "" "$configure_args" \
        $extension_type "$after_install"
}

function _checkout_extension {
    local name=$1
    local revision="$2"
    local url_source="$3"
    local source_cwd="$4"
    local configure_args="$5"
    local extension_type="$6"
    local after_install="$7"
    local source_dir="$PHP_BUILD_TMPDIR/source/$name-master"

    if [ -d "$source_dir" ] && [ -d "$source_dir/.git" ]; then
        log "$name" "Updating $name from Git Master"
        cd "$source_dir"
        git clean -fdx
        git reset --hard HEAD
        git pull origin master > /dev/null
        cd "$cwd"
    else
        log "$name" "Fetching from $url_source"
        git clone "$url_source" "$source_dir" 2>&4
        log "$name" "commit $(cd ${source_dir} && git rev-parse HEAD)"
    fi

    if [ -n "$revision" ]; then
        log "$name" "Checkout specified revision: $revision"
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

    BUILD_EXTENSION_OUTPUT='5'
    if [ "$VERBOSE" ]; then
        BUILD_EXTENSION_OUTPUT='4'
    fi

    log "$name" "Compiling $name in $source_dir"

    cd "$source_dir/$source_cwd"

    {
        $PREFIX/bin/phpize
        "$(pwd)/configure" --with-php-config=$PREFIX/bin/php-config \
            $configure_args

        make
        make install
    } 2>&4 1>&$BUILD_EXTENSION_OUTPUT

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
