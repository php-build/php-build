#!/usr/bin/env bats

@test "Installs pyrus executable" {
    [ -f "$TEST_PREFIX/bin/pyrus" ]
}

