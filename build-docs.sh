#!/bin/sh

if [ -z "$RONN_PATH" ]; then
    RONN_PATH=$(which ronn)
fi

if [ -z "$RONN_PATH" ] || [ ! -f "$RONN_PATH" ]; then
    echo "Seams like ronn is not installed." >&2
    read -p "Install ronn? (y/n) " INSTALL_RONN

    if [ -z "$INSTALL_RONN" ] || [ "$INSTALL_RONN" = "y" ]; then
        sudo gem install ronn
    else
        exit 1
    fi
fi

for manpage in man/*.ronn
do
    echo "Building $manpage" >&2
    "$RONN_PATH" "$manpage"
done

echo "Building README.md" >&2
"$RONN_PATH" --markdown --pipe "man/php-build.1.ronn" > "README.md"

echo "Done" >&2
