#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

if [ -z "$PREFIX" ]; then
    PREFIX="/usr/local"
fi

echo "Installing php-build in '$PREFIX'"

BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share"
MAN_DIR="$PREFIX/share/man"

echo -n "  - creating directories..."

[ ! -d "$BIN_DIR" ]          && mkdir -p "$BIN_DIR"
[ ! -d "$MAN_DIR" ]          && mkdir -p "$MAN_DIR"
[ ! -d "$SHARE_DIR" ]        && mkdir -p "$SHARE_DIR"
[ ! -d "$MAN_DIR/man1" ]     && mkdir -p "$MAN_DIR/man1"
[ ! -d "$MAN_DIR/man5" ]     && mkdir -p "$MAN_DIR/man5"

echo " done."

echo -n "  - copying files..."

cp -r "$DIR/"{bin,share} "$PREFIX/"
cp "$DIR/man/php-build.1" "$MAN_DIR/man1/"
cp "$DIR/man/php-build.5" "$MAN_DIR/man5/"

echo " done."

echo "Done."
