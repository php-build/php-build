#!/usr/bin/env bash 	
# 	
# This shell scriplet is meant to be included by other shell scripts 	
# to set up some variables and a few helper shell functions.

function install_apc {
    install_extension "apc" "$1"
}
