#!/usr/bin/env bats

@test "Installs xdebug.so" {
    local xdebug_installed="$(echo "$DEFINITION_CONFIG" | grep '^install_xdebug')"
    local ext_dir=$("$TEST_PREFIX/bin/php" -r "echo ini_get('extension_dir');")

    [ -z $xdebug_installed ] && skip "Xdebug isn't installed"
    [ -f "$ext_dir/xdebug.so" ]
}

@test "Enables Xdebug" {
    local xdebug_installed="$(echo "$DEFINITION_CONFIG" | grep '^install_xdebug')"

    [ -z $xdebug_installed ] && skip "Xdebug isn't installed"
    "$TEST_PREFIX/bin/php" -i | grep "xdebug"
}

