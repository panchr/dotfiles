#!/bin/bash

DIR="$( dirname -- "$BASH_SOURCE"; )";

PACKAGE_MANAGER='brew'
REPOSITORY_MANAGER='brew tap'

case `uname` in
    Darwin)
	# Ensure that brew is installed.
	if ! command -v "$PACKAGE_MANAGER" &>/dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
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
		 htop \
		 tree

case `uname` in
    Darwin)
		# General utilities
		$PACKAGE_MANAGER install \
					the_silver_searcher \
					go \
					bazelisk \
					zsh \
					tmux \
					grep \
					openssh \
					git \
					tree \
					gnupg \
					findutils \
					coreutils \
					awscli \
					vnstat \
					watch \
					telnet \
					pinentry-mac \
					noti \
					claude-code \
					gh

		# Emacs.
		$REPOSITORY_MANAGER d12frosted/emacs-plus
		$PACKAGE_MANAGER install emacs-plus

		# Python.
		$PACKAGE_MANAGER install \
						 pyenv \
						 python@3.10 \
						 openssl \
						 readline \
						 sqlite3 \
						 xz \
						 zlib

    ;;
    Linux)
	$REPOSITORY_MANAGER ppa:git-core/ppa
	$REPOSITORY_MANAGER ppa:kelleyk/emacs
	$PACKAGE_MANAGER update

	$PACKAGE_MANAGER install \
			 make \
			 build-essential \
			 libssl-dev \
			 zlib1g-dev \
			 libbz2-dev \
			 libreadline-dev \
			 libsqlite3-dev \
			 libpq-dev \
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
			 git \
			 emacs26 \
			 silversearcher-ag
    ;;
    FreeBSD)
	# do nothing
    ;;
esac

# Other installations
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pyenv install --skip-existing 3.10.3
pyenv local 3.10.3
pip3 install --upgrade \
    pip \
    pipenv

# iterm2 shell integration.
bash "$DIR/install-iterm2-sh-integration.sh"
