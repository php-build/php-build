#!/bin/sh
set -eu

if [ -f /etc/os-release ]; then
	. /etc/os-release
fi

if [ -f /etc/debian_version ]; then
	DISTRO=debian
elif [ -f /etc/redhat-release ]; then
	DISTRO=rhel
elif [ "$(uname -s)" = "Darwin" ]; then
	DISTRO=darwin
else
	echo "Unsupported operating system"
	exit 1
fi

if command -v sudo; then
	SUDO=sudo
else
	SUDO=
fi

# NOTES:
#   * --with-libedit can be used to replace libreadline-dev with libedit-dev
#   * libcurl4-openssl-dev may be used with PHP 5.6 or higher, but it will conflict
#     with custom openssl 1.0.2 builds required for PHP 5.5 and lower.

case $DISTRO in
	debian)
		export DEBIAN_FRONTEND=nointeractive
		$SUDO apt-get update -q
		$SUDO apt-get install -q -y --no-install-recommends \
			autoconf2.13 \
			autoconf2.64 \
			autoconf \
			bash \
			bison \
			build-essential \
			ca-certificates \
			curl \
			findutils \
			git \
			libbz2-dev \
			libcurl4-gnutls-dev \
			libicu-dev \
			libjpeg-dev \
			libmcrypt-dev \
			libonig-dev \
			libpng-dev \
			libreadline-dev \
			libsqlite3-dev \
			libssl-dev \
			libtidy-dev \
			libxml2-dev \
			libxslt1-dev \
			libzip-dev \
			pkg-config \
			re2c \
			zlib1g-dev
		;;
	rhel)
		$SUDO dnf install -y yum-utils epel-release
		if [[ "$VERSION_ID" =~ ^8 ]]; then
			$SUDO dnf install -y dnf-plugins-core
			$SUDO dnf config-manager --set-enabled powertools
			$SUDO dnf install -y autoconf autoconf213
		else
			$SUDO dnf install -y dnf-plugins-core
			$SUDO dnf config-manager --set-enabled crb
			$SUDO dnf -y swap curl-minimal curl
			$SUDO dnf install -y autoconf
		fi
		$SUDO dnf install -y \
			bash \
			bison \
			bzip2 \
			bzip2-devel \
			curl \
			diffutils \
			findutils \
			gcc \
			gcc-c++ \
			git \
			libarchive \
			libcurl-devel \
			libicu-devel \
			libjpeg-turbo-devel \
			libmcrypt-devel \
			libpng-devel \
			libtidy-devel \
			libxml2-devel \
			libxslt-devel \
			make \
			oniguruma-devel \
			openssl-devel \
			patch \
			pkgconf \
			readline-devel \
			sqlite-devel \
			zlib-devel \
			cmake3
		$SUDO curl https://github.com/nih-at/libzip/releases/download/v1.7.3/libzip-1.7.3.tar.gz -L -o libzip-1.7.3.tar.gz && \
			tar -zxvf libzip-1.7.3.tar.gz && \
			cd libzip-1.7.3 && \
			cmake3 . -DCMAKE_INSTALL_PREFIX=/usr && \
			make && \
			make install
		;;
	darwin)
		# brew install will fail if a package is already installed
		# using brew bundle seems to be the recommended alternative
		# https://github.com/Homebrew/brew/issues/2491
		brew bundle --file=- <<-EOS
brew "autoconf"
brew "autoconf@2.13"
brew "bzip2"
brew "icu4c"
brew "libedit"
brew "libiconv"
brew "libjpeg"
brew "libxml2"
brew "libzip"
brew "oniguruma"
brew "openssl"
brew "pkg-config"
brew "python"
brew "re2c"
brew "tidy-html5"
brew "zlib"
EOS
		;;
	*)
esac
