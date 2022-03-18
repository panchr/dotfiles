#!/bin/bash

PACKAGE_MANAGER='brew'
REPOSITORY_MANAGER='brew tap'

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
		 htop \
		 tree

case `uname` in
    Darwin)
        $REPOSITORY_MANAGER d12frosted/emacs-plus
	$PACKAGE_MANAGER install \
					the_silver_searcher \
					go \
					pyenv \
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
					emacs-plus \
					python@3.9
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
pyenv install --skip-existing 3.8.1
pyenv local 3.8.1
pip install --upgrade \
    pip \
    pipenv
