#!/bin/bash

PACKAGE_MANAGER='brew'
REPOSITORY_MANAGER='brew'

case `uname` in
    Darwin)
	# do nothing
    ;;
    Linux)
	PACKAGE_MANAGER='sudo apt-get -y'
	REPOSITORY_MANAGER='sudo add-apt-repository -y'
    ;;
    FreeBSD)
	# do nothing
    ;;
esac

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
	$REPOSITORY_MANAGER ppa:git-core/ppa
	$PACKAGE_MANAGER update

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

# Other installations
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pyenv install --skip-existing 3.8.1
pyenv local 3.8.1
pip install --upgrade \
    pip \
    pipenv
