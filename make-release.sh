#!/usr/bin/env bash

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "make-release.sh: No Version given." >&2
    exit 1
fi

./build-docs.sh "$VERSION"

# Replace {{VERSION}} with the version passed as argument:
sed -e "s/{{VERSION}}/$VERSION/" -i '' "bin/php-build"
