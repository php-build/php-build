#!/usr/bin/env bash

PHP="$PREFIX/bin/php"

install_composer() {

    download_composer
    # copy_composer_phar

    log Composer "Installing executable in $PREFIX/bin/composer"

    cp -f "$PHP_BUILD_TMPDIR/packages/composer.phar" "$PREFIX/bin/composer.phar"

    mv "$PREFIX/bin/composer.phar" "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"
}

download_composer() {
    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="https://getcomposer.org/download/latest-stable/composer.phar"
    fi

    log Composer "Downloading from $composer_url"

    if [ -f "$PHP_BUILD_TMPDIR/packages/composer.phar" ]; then
      rm "$PHP_BUILD_TMPDIR/packages/composer.phar"
    fi

    curl -s $composer_url -o "$PHP_BUILD_TMPDIR/packages/composer.phar"
}

copy_composer_phar() {
    cp -f "$PHP_BUILD_TMPDIR/packages/composer.phar" "$PREFIX/bin/composer.phar"
}
