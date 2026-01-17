#!/usr/bin/env bash

PHP="$PREFIX/bin/php"

install_composer() {

    log Composer "Downloading from $composer_url"

    download_composer

    log Composer "Installing executable in $PREFIX/bin/composer"

    mv "$PREFIX/bin/composer.phar" "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"

    log Composer "Downloaded composer."
}

download_composer() {

    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="https://getcomposer.org/download/latest-stable/composer.phar"
    fi

    if [ ! -d "$PREFIX/bin" ] ; then
      mkdir -p "$PREFIX/bin"
    fi

    if [ -f "$PREFIX/bin/composer.phar" ]; then
      rm "$PREFIX/bin/composer.phar"
    fi

    exec curl -sS $composer_url -o "$PREFIX/bin/composer.phar"
}
