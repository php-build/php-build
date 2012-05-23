#!/usr/bin/env bash

TIME="$(date "+%Y%m%d%H%M%S")"
DEFINITIONS="$(./bin/php-build --definitions)"
STABLE_DEFINITIONS="5.3.13 5.4.3"

BUILD_PREFIX="/tmp/php-build-test-$TIME"
BUILD_LIST=
FAILED=

if ! which "bats" > /dev/null; then
    echo "You need http://github.com/sstephenson/bats installed." >&2
    exit 1
fi

case "$CONFIG" in
    all)
        BUILD_LIST="$DEFINITIONS"
        ;;
    stable)
        BUILD_LIST="$STABLE_DEFINITIONS"
        ;;
    *)
        BUILD_LIST="$@"
        ;;
esac

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
