#!/bin/bash

set -euxo pipefail

DIR="$(dirname -- "$BASH_SOURCE")"
CONFIG_DIR=$(cd -- "$DIR/.." && pwd -P)

usage() {
	cat <<-EOF
		Usage: install-packages.sh [OPTIONS]

		Install system packages for the current platform.

		Options:
		  --help      Show this help message
	EOF
}

for arg in "$@"; do
	case "$arg" in
	--help)
		usage
		exit 0
		;;
	*) echo "Unknown flag: $arg" && exit 1 ;;
	esac
done

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
	"${PACKAGE_MANAGER[@]}" bundle install --file="$CONFIG_DIR/Brewfile"
	;;
Linux)
	"${REPOSITORY_MANAGER[@]}" ppa:git-core/ppa
	# "${REPOSITORY_MANAGER[@]}" ppa:kelleyk/emacs
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
		python3-openssl \
		git \
		silversearcher-ag \
		fzf \
		bat

	sudo bash "$DIR/install-emacs30-ubuntu.sh"
	curl -fsSL https://mise.run | sh
	;;
FreeBSD)
	# do nothing
	;;
esac
