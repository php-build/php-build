#!/usr/bin/env bash

function uprofiler_after_install {
    local source_dir=$1
    local ini_file=$2
    local extension_home=$5

    cp -r "$source_dir/uprofiler_html" "$extension_home"
    cp -r "$source_dir/uprofiler_lib" "$extension_home"

    echo "uprofiler.output_dir=\"/var/tmp/uprofiler\"" >> $ini_file
}
