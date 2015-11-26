#!/bin/sh

TEMP_PAGES_DIR=/var/tmp/php-build-gh-pages
GIT_REPO="git@github.com:php-build/php-build"

update_gh_pages() {
    if [ -d "$TEMP_PAGES_DIR" ]; then
        local cwd="$(pwd)"
        cd "$TEMP_PAGES_DIR"
        git pull --ff origin gh-pages
        cd "$cwd"
    else
        git clone "$GIT_REPO" -b gh-pages "$TEMP_PAGES_DIR"
    fi

    cp -R man/ "$TEMP_PAGES_DIR/man"

    local cwd="$(pwd)"
    cd "$TEMP_PAGES_DIR"

    git add --all "$TEMP_PAGES_DIR/man"
    git commit -m "Update man pages"

    git push origin gh-pages
    cd "$cwd"
}

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
    echo "Building $manpage... " >&2
    "$ronn" "$manpage"
    echo "Done" >&2
done

if [ -z "$NO_GITHUB_PAGES" ]; then
    echo
    echo "Updating online man pages... " >&2
    update_gh_pages
    echo "Done" >&2
fi

