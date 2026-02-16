#!/usr/bin/env bash

install_pie() {

    local pie="$1"
    local pie_path="$PREFIX/bin/pie"

    if [[ -z "$pie_url" ]]; then
        pie_url="https://github.com/php/pie/releases/latest/download/pie.phar"
    fi

    log Pie "Downloading from $pie_url"

    if [[ ! -d "$PREFIX/bin" ]] ; then
        mkdir -p "$PREFIX/bin"
    fi
    if [[ -f "$pie_path" ]] ; then
        rm -f "$pie_path"
    fi

    curl -sSL "$pie_url" -o "$pie_path"
    if [[ $? -ne 0 ]] ; then
      wget -q -O "$pie_path" "$pie_url"
      if [[ $? -ne 0 ]] ; then
        log Composer "You don't have curl nor wget."
        exit 2
      fi
    fi

    chmod +x "$pie_path"

    log Pie "Downloaded."
}
