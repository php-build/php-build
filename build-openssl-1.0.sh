#!/bin/sh
#
# PHP 5.6 and older require OpenSSL 1.0.2, which is too old for most modern
# operating systems. This script downloads, builds and installs OpenSSL 1.0.2
# for use in PHP builds.
#

set -ex

BUILD_DIR=/tmp/openssl-1.0.2-build
TARBALL=openssl-1.0.2t.tar.gz
MD5SUM=ef66581b80f06eae42f5268bc0b50c6d
PREFIX=/usr/local/opt/openssl@1.0

if command -v sudo ; then
	SUDO=sudo
else
	SUDO=
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
curl -OLs https://www.openssl.org/source/$TARBALL

if command -v md5sum; then
	echo "$MD5SUM $TARBALL" | md5sum -c
fi

tar xzf $TARBALL --strip-components=1 -C "$BUILD_DIR"

CONFIG_SCRIPT=./config
ARCH_ARGS=""
if [ "$(uname -s)" = Darwin ] && [ "$(uname -m)" = x86_64 ]; then
	ARCH_ARGS="darwin64-x86_64-cc enable-ec_nistp_64_gcc_128"
	CONFIG_SCRIPT=./Configure
fi

$CONFIG_SCRIPT -fPIC shared no-ssl2 no-ssl3 no-zlib $ARCH_ARGS --prefix=/usr/local/opt/openssl@1.0

make depend

make -j $(nproc)

$SUDO make install_sw

# if this multiarch system uses lib64, create a symlink for it
# this will ensure that PHP configure script will succeed with any
# combination of --with-openssl and --with-libdir
if [ -d /usr/lib64 ]; then
	$SUDO ln -s "$PREFIX/lib" "$PREFIX/lib64"
fi

rm -rf "$BUILD_DIR"
