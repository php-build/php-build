#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

if [ -z "$PREFIX" ]; then
    PREFIX="/usr/local"
fi

echo "Installing php-build in $PREFIX"

echo -n "  - Creating Directories..."
[ ! -d "$PREFIX/bin" ] && mkdir -p "$PREFIX/bin"
[ ! -d "$PREFIX/share/man1" ] && mkdir -p "$PREFIX/share/man1"
[ ! -d "$PREFIX/tmp/php-build/packages" ] && mkdir -p "$PREFIX/tmp/php-build/packages"
[ ! -d "$PREFIX/tmp/php-build/source" ] && mkdir -p "$PREFIX/tmp/php-build/source"
[ ! -d "$PREFIX/var/log/php-build" ] && mkdir -p "$PREFIX/var/log/php-build"
echo " Done."

echo -n "  - Copying files..."
cp -R "$DIR/"{bin,share} "$PREFIX/"

cp "$DIR/man/php-build.1" "$PREFIX/share/man/man1/"

echo " Done."
