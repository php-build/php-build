#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

# PHP.next Development releases depend on current XDebug development snapshots
function install_xdebug_master {
    install_extension_source "xdebug" "$1"
}

# On the contrary, for stable PHP versions we need a stable XDebug version
function install_xdebug {
    install_extension "xdebug" "$1"
}

function xdebug_after_install {
    local source_dir=$1
    local ini_file=$2
    local extension_type=$3
    local extension_dir=$4

    if [ -z "$PHP_BUILD_XDEBUG_ENABLE" ]; then
        PHP_BUILD_XDEBUG_ENABLE=yes
    fi

     # Comment out the lines in the xdebug.ini when the env variable
    # is set to something to "no"
    local conf_line_prefix=
    if [ "$PHP_BUILD_XDEBUG_ENABLE" == "off" ] || [ "$PHP_BUILD_XDEBUG_ENABLE" == "no" ]; then
        log "XDebug" "XDebug is commented out in $xdebug_ini. Remove the \";\" to enable it."
        conf_line_prefix=";"
    fi

    echo -n "$conf_line_prefix" > $ini_file
    echo "$extension_type=\"$extension_dir/xdebug.so\"" >> $ini_file
    echo -n "$conf_line_prefix" >> $ini_file
    echo "html_errors=on" >> $ini_file
}
