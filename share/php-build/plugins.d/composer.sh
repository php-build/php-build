#!/usr/bin/env bash

PHP="$PREFIX/bin/php"

install_composer() {
    download_composer
    copy_composer_phar

    log Composer "Installing executable in $PREFIX/bin/composer"

    mv "$PREFIX/bin/composer.phar" "$PREFIX/bin/composer"

    chmod +x "$PREFIX/bin/composer"
}

download_composer() {
    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="https://getcomposer.org/composer.phar"
    fi

    if [ ! -f "$PHP_BUILD_TMPDIR/packages/composer.phar" ]; then
        log Composer "Downloading from $composer_url"
        wget -P "$PHP_BUILD_TMPDIR/packages" $composer_url
    else
        log Composer "self updating in $PHP_BUILD_TMPDIR/packages/composer.phar"
        $PHP $PHP_BUILD_TMPDIR/packages/composer.phar self-update
    fi
}

copy_composer_phar() {
    yes | cp "$PHP_BUILD_TMPDIR/packages/composer.phar" "$PREFIX/bin/composer.phar"
}
