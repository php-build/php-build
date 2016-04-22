#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_zendopcache_master {
    install_extension_source "zendopcache" "$1"
}

function install_zendopcache {
    install_extension "zendopcache" "$1"
}

function zendopcache_after_install {
    local source_dir=$1
    local ini_file=$2
    local extension_type=$3
    local extension_dir=$4

    # While the extension name is ZendOpcache, its extension is named "opcache.so"
    # We need to reflect this in the configuration
    echo "$extension_type=\"$extension_dir/opcache.so\"" > $ini_file
}
