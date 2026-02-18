#!/usr/bin/env bash

install_composer() {

    local composer_url="$1"
    local composer_path="$PREFIX/bin/composer"

    if [[ -z "$composer_url" ]]; then
        composer_url="https://getcomposer.org/download/latest-stable/composer.phar"
    fi

    log Composer "Downloading from $composer_url"

    if [[ ! -d "$PREFIX/bin" ]] ; then
        mkdir -p "$PREFIX/bin"
    fi
    if [[ -f "$composer_path" ]] ; then
        rm -f "$composer_path"
    fi

    curl -sSL "$composer_url" -o "$composer_path"
    if [[ $? -ne 0 ]] ; then
      wget -q -O "$composer_path" "$composer_url"
      if [[ $? -ne 0 ]] ; then
        log Composer "You don't have curl nor wget."
        exit 2
      fi
    fi

    chmod +x "$composer_path"

    log Composer "Downloaded."
}
