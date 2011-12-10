#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

if [ -z "$PREFIX" ]; then
    PREFIX="/usr/local"
fi

echo "Installing php-build in $PREFIX"

echo -n "  - Creating Directories..."
[ ! -d "$PREFIX/bin" ] && mkdir -p "$PREFIX/bin"
[ ! -d "$PREFIX/man" ] && mkdir -p "$PREFIX/man"
[ ! -d "$PREFIX/share" ] && mkdir -p "$PREFIX/share"
[ ! -d "$PREFIX/tmp" ] && mkdir -p "$PREFIX/tmp"
[ ! -d "$PREFIX/var" ] && mkdir -p "$PREFIX/var"
echo " Done."

echo -n "  - Copying files..."
cp -R "$DIR/"{bin,man,share} "$PREFIX/"

echo " Done."
