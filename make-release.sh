#!/usr/bin/env bash

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "make-release.sh: No Version given." >&2
    exit 1
fi

echo "Releasing $VERSION"
echo "==="
echo

echo "--> Creating release branch... "

{
git branch "release/$VERSION" master
git checkout "release/$VERSION"
} > /dev/null

echo "Done"

echo "---> Building documentation... "
./build-docs.sh "$VERSION" > /dev/null
echo "Done"

echo "---> Updating version number to \"$VERSION\"... "
sed -E -e "s/(PHP_BUILD_VERSION=\")(.+)(\")/\1$VERSION\3/" -i '' bin/php-build
echo "Done"

echo "---> Staging changed files... "
git add bin/
git add man/
echo "Done"

git commit -m "Release $VERSION"

echo "---> Creating tag \"v$VERSION\"... "
git tag -a "v$VERSION" -m "Release $VERSION" > /dev/null
echo "Done"

echo
echo "Successfully released $VERSION"

