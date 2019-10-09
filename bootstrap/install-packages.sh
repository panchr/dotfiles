#!/bin/bash

PACKAGE_MANAGER='apt-get'

$PACKAGE_MANAGER install \
		 tmux \
		 emacs \
		 htop \
		 tree \
		 libpq-dev \
		 silversearcher-ag

case `uname` in
    Darwin)
	# do nothing
    ;;
    Linux)
	$PACKAGE_MANAGER install \
			 make \
			 build-essential \
			 libssl-dev \
			 zlib1g-dev \
			 libbz2-dev \
			 libreadline-dev \
			 libsqlite3-dev \
			 wget \
			 curl \
			 llvm \
			 libncurses5-dev \
			 libncursesw5-dev \
			 xz-utils \
			 tk-dev \
			 libffi-dev \
			 liblzma-dev \
			 python-openssl \
			 git
    ;;
    FreeBSD)
	# do nothing
    ;;
esac
