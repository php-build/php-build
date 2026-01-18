#!/usr/bin/env bash

PHP="$PREFIX/bin/php"

install_composer() {

    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="https://getcomposer.org/download/latest-stable/composer.phar"
    fi

    log Composer "Downloading from $composer_url"

    if [ ! -d "$PREFIX/bin" ] ; then
        mkdir -p "$PREFIX/bin"
    fi

    curl -sS "$composer_url" -o "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"

    log Composer "Downloaded."
}
