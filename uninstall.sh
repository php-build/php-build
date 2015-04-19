#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

if [ -z "$PREFIX" ]; then
    PREFIX="/usr/local"
fi

echo "Uninstalling php-build from '$PREFIX'"

BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share"
MAN_DIR="$PREFIX/share/man"

echo -n "  - removing files..."

rm -f "$BIN_DIR/php-build"
rm -f "$BIN_DIR/phpenv-install"
rm -f "$BIN_DIR/rbenv-install"
rm -f "$MAN_DIR/man1/php-build.1"
rm -f "$MAN_DIR/man5/php-build.5"
rm -rf "$SHARE_DIR/php-build"

echo " done."

echo "Done."
