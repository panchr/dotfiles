#!/bin/bash

set -ex

# The Emacs version to install.
EMACS_VERSION=30.1

# The prefix to install Emacs into.
INSTALL_PREFIX=${INSTALL_PREFIX:-/usr/local}

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

# Add deb-src so that emacs' build dependencies can be installed.
echo "deb-src http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

apt update

# Stop apt-get from complaining about postfix.
echo "postfix postfix/mailname string my.hostname.example" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive

apt-get build-dep emacs && \
	apt install imagemagick \
		libmagickwand-dev \
		libmagickcore-dev \
		libtree-sitter-dev \
		libtree-sitter0 \
		sqlite3 \
		libsqlite3-dev \
		libgccjit-10-dev \
		libgccjit0 \
		gcc-10

mkdir -p ~/misc/emacs
cd ~/misc/emacs

# Re-clone emacs from scratch if it already exists.
rm -rf emacs/
git clone --depth 1 --branch emacs-$EMACS_VERSION https://github.com/emacs-mirror/emacs.git
cd emacs

export CC=gcc-10
./autogen.sh
./configure --prefix="$INSTALL_PREFIX" --with-native-compilation=aot --with-tree-sitter --with-modules --with-threads --without-mailutils --without-xaw3d --with-x-toolkit=no --with-xpm=ifavailable --with-gif=ifavailable --with-gnutls=ifavailable --with-imagemagick=ifavailable

make -j$(nproc --ignore=2)
make -j$(nproc --ignore=2) install

ln -f /usr/local/bin/emacs-$EMACS_VERSION /usr/bin/emacs
