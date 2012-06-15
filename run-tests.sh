#!/usr/bin/env bash

TIME="$(date "+%Y%m%d%H%M%S")"

DEFINITIONS="$(./bin/php-build --definitions)"
STABLE_DEFINITIONS="5.3.14 5.4.4"

BUILD_PREFIX="/tmp/php-build-test-$TIME"
BUILD_LIST=
FAILED=

usage() {
    echo "Usage: ./run-tests.sh all|stable|<definition>,..."
}

if ! which "bats" > /dev/null; then
    echo "You need http://github.com/sstephenson/bats installed." >&2
    exit 1
fi

case "$1" in
    all)
        BUILD_LIST="$DEFINITIONS"
        ;;
    stable)
        BUILD_LIST="$STABLE_DEFINITIONS"
        ;;
    *)
        if [ $# -eq 0 ]; then
            usage
            exit 1
        fi
        BUILD_LIST="$@"
        ;;
esac

echo "Testing definitions $BUILD_LIST"
echo

for definition in $BUILD_LIST; do
    echo -n "Building '$definition'..."
    if ./bin/php-build --pear "$definition" "$BUILD_PREFIX/$definition" &> /dev/null; then
        echo "OK"

        export TEST_PREFIX="$BUILD_PREFIX/$definition"

        echo "Running Tests..."

        for t in tests/*.bats; do
            bats "$t"
        done
    else
        echo "FAIL"
        FAILED="$FAILED $definition"
    fi
done

if [ -z "$FAILED" ]; then
    rm -rf "$BUILD_PREFIX"
else
    echo "Build fail."
    echo "Failed Definitions:$FAILED"
    exit 1
fi
