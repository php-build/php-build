#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

if [ -z "$PREFIX" ]; then
    PREFIX="/usr/local"
fi

echo "Installing php-build in $PREFIX"

BIN_DIR="$PREFIX/bin"
MAN_DIR="$PREFIX/share/man"
TMP_DIR="/tmp/php-build"

echo -n "  - Creating Directories..."

[ ! -d "$BIN_DIR" ]          && mkdir -p "$BIN_DIR"
[ ! -d "$MAN_DIR" ]          && mkdir -p "$MAN_DIR"
[ ! -d "$MAN_DIR/man1" ]     && mkdir -p "$MAN_DIR/man1"
[ ! -d "$MAN_DIR/man5" ]     && mkdir -p "$MAN_DIR/man5"
[ ! -d "$TMP_DIR/packages" ] && mkdir -p "$TMP_DIR/packages"
[ ! -d "$TMP_DIR/source" ]   && mkdir -p "$TMP_DIR/source"

echo " Done."

chmod -R 0777 "$TMP_DIR"

echo -n "  - Copying files..."
cp -R "$DIR/"{bin,share} "$PREFIX/"

cp "$DIR/man/php-build.1" "$MAN_DIR/man1/"
cp "$DIR/man/php-build.5" "$MAN_DIR/man5/"

echo " Done."
