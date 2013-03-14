#!/usr/bin/env bash

TMP="/var/tmp/php-build"

download_composer() {
    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="http://getcomposer.org/composer.phar"
    fi

    echo "Composer" "Downloading from $composer_url" >&3

    if [ ! -f "$TMP/packages/composer.phar" ]; then
        wget -P "$TMP/packages" $composer_url
    fi
}

copy_composer_phar() {
    cp "$TMP/packages/composer.phar" "$PREFIX/bin/composer.phar"
}

install_composer() {
    download_composer
    copy_composer_phar

    echo "Composer" "Installing executable in $PREFIX/bin/composer" >&3
    
    mv "$PREFIX/bin/composer.phar" "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"
}

install_composer