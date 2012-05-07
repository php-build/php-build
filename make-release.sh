#!/usr/bin/env bash

VERSION="$1"

./build-docs.sh "$VERSION"

# Replace {{VERSION}} with the version passed as argument:

sed -e "s/{{VERSION}}/$VERSION/" -i '' "bin/php-build"
