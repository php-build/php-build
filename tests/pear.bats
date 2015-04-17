#!/usr/bin/env bats

@test "Enables pear auto_discover" {
    "$TEST_PREFIX/bin/pear" config-get auto_discover | grep "1"
}

