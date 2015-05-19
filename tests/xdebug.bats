#!/usr/bin/env bats

@test "Installs xdebug.so" {
    local ext_dir=$("$TEST_PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    [ -f "$ext_dir/xdebug.so" ]
}

@test "Enables XDebug" {
    "$TEST_PREFIX/bin/php" -i | grep "xdebug"
}

