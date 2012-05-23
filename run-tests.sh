#!/usr/bin/env bash

CONFIG="$1"
TIME="$(date "+%Y%m%d%H%M%S")"
DEFINITIONS="$(./bin/php-build --definitions)"
STABLE_DEFINITIONS="5.3.13 5.4.3"

BUILD_PREFIX="/tmp/php-build-test-$TIME"
BUILD_LIST=

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
        if echo "$DEFINITIONS" | grep "$CONFIG" > /dev/null; then
            BUILD_LIST="$CONFIG"
        else
            echo "Config '$CONFIG' not found." >&2
            exit 1
        fi
        ;;
esac

STATUS=0

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
        STATUS=1
    fi
done

if [ "$STATUS" -eq 0 ]; then
    rm -rf "$BUILD_PREFIX"
fi

exit $STATUS
