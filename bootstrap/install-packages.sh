#!/bin/bash

set -euxo pipefail

DIR="$(dirname -- "$BASH_SOURCE")"

PACKAGE_MANAGER=(brew)
REPOSITORY_MANAGER=(brew tap)

case $(uname) in
Darwin)
	# Ensure that brew is installed.
	if ! command -v "$PACKAGE_MANAGER" &>/dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	;;
Linux)
	PACKAGE_MANAGER=(sudo apt-get -y)
	REPOSITORY_MANAGER=(sudo add-apt-repository -y)
	;;
FreeBSD)
	# do nothing
	;;
esac

case $(uname) in
Darwin)
	"${PACKAGE_MANAGER[@]}" bundle install
	;;
Linux)
	"${REPOSITORY_MANAGER[@]}" ppa:git-core/ppa
	"${REPOSITORY_MANAGER[@]}" ppa:kelleyk/emacs
	"${PACKAGE_MANAGER[@]}" update

	"${PACKAGE_MANAGER[@]}" install \
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
		silversearcher-ag \
		fzf \
		bat

	bash "$DIR/install-emacs30-ubuntu.sh"
	curl -fsSL https://mise.run | sh
	;;
FreeBSD)
	# do nothing
	;;
esac

# Install language servers.
go install golang.org/x/tools/gopls@latest
npm install -g pyright
npm install -g bash-language-server
npm install -g typescript-language-server typescript

bun install -g tokscale@latest
