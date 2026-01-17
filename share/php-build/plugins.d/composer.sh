#!/usr/bin/env bash

PHP="$PREFIX/bin/php"

install_composer() {

    download_composer

    log Composer "Installing executable in $PREFIX/bin/composer"

    mv "$PREFIX/bin/composer.phar" "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"
}

download_composer() {

    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="https://getcomposer.org/download/latest-stable/composer.phar"
    fi

    log Composer "Downloading from $composer_url"

    if [ -f "$PREFIX/bin/composer.phar" ]; then
      rm "$PREFIX/bin/composer.phar"
    fi

    curl -s $composer_url -o "$PREFIX/bin/composer.phar"
}
