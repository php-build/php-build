#!/bin/sh

RONN_PATH=$(which ronn)

if [ -z "$RONN_PATH" ] || [ ! -f "$RONN_PATH" ]; then
    echo "Seams like ronn is not installed." >&2
    INSTALL_RONN=$(read -p "Install ronn? (y/n)")
    if [ -z "$INSTALL_RONN" ] || [ "$INSTALL_RONN" = "y" ]; then
        sudo gem install ronn
    fi
fi

echo "Building man-pages" >&2
"$RONN_PATH" "man/php-build.1.ronn"

echo "Building README.md" >&2
"$RONN_PATH" --markdown --pipe "man/php-build.1.ronn" > "README.md"

echo "Done" >&2
