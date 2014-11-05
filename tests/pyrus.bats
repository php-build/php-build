#!/usr/bin/env bats

@test "Installs pyrus executable" {
    if [ $INSTALL_PYRUS -ne 0 ]; then
        skip "Pyrus wasn't configured to be installed by definition file"
    fi

    [ -f "$TEST_PREFIX/bin/pyrus" ]
}

