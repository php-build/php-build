#!/usr/bin/env bash

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "make-release.sh: No Version given." >&2
    exit 1
fi

SED_REGEX_SWITCH='E'

# sed switch -E is BSD specific and only added to UNIX sed after v4.2
# fallback to -r if -E does not work
if ! sed -$SED_REGEX_SWITCH '' /dev/null > /dev/null 2>&1; then
    SED_REGEX_SWITCH='r'
fi

echo "Releasing $VERSION"
echo "==="
echo

echo "---> Creating release branch... "

{
git branch "release/$VERSION" master
git checkout "release/$VERSION"
} > /dev/null

echo "Done"

echo
echo "---> Building documentation... "
./build-docs.sh "$VERSION" > /dev/null
echo "Done"

echo
echo "---> Updating version number to \"$VERSION\"... "
sed -${SED_REGEX_SWITCH} -e "s/(PHP_BUILD_VERSION=\")(.+)(\")/\1$VERSION\3/" -i '' bin/php-build
./bin/php-build --version
echo "Done"

echo
echo "---> Staging changed files... "
git add bin/
git add man/
git commit -m "Release $VERSION"
echo "Done"

echo
echo "---> Creating tag \"v$VERSION\"... "
git tag -a "v$VERSION" -m "Release $VERSION" > /dev/null
echo "Done"

echo
echo "Successfully released $VERSION"

