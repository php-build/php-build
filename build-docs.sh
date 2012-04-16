#!/bin/sh

VERSION="$1"

if [ -z "$RONN_PATH" ]; then
    ronn=$(which ronn)
else
    ronn="$RONN_PATH"
fi

if [ -z "$ronn" ] || [ ! -f "$ronn" ]; then
    echo "Seams like ronn is not installed." >&2
    read -p "Install ronn? (y/n) " INSTALL_RONN

    if [ -z "$INSTALL_RONN" ] || [ "$INSTALL_RONN" = "y" ]; then
        sudo gem install ronn
    else
        exit 1
    fi
fi

export RONN_MANUAL="php-build"
export RONN_ORGANIZATION="php-build $VERSION"

for manpage in man/*.ronn
do
    echo "Building $manpage" >&2
    "$ronn" "$manpage"
done

echo "Done" >&2
