#!/usr/bin/env bash

TMP="/var/tmp/php-build"
PHP="/usr/bin/env php"

download_composer() {
    local composer_url="$1"

    if [ -z "$composer_url" ]; then
        composer_url="http://getcomposer.org/composer.phar"
    fi

    if [ ! -f "$TMP/packages/composer.phar" ]; then
        echo "Composer" "Downloading from $composer_url" >&3
        wget -P "$TMP/packages" $composer_url
    else
        echo "Composer" "self updating in $TMP/packages/composer.phar" >&3
        $PHP $TMP/packages/composer.phar self-update
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