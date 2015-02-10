#!/usr/bin/env bash
#
# This shell scriplet is meant to be included by other shell scripts
# to set up some variables and a few helper shell functions.

function install_xhprof_master {
    install_extension_source "xhprof" "$1"
}

function install_xhprof {
    install_extension xhprof "$1"
}

function xhprof_after_install {
    echo "xhprof.output_dir=\"/var/tmp/xhprof\"" >> $2
}
