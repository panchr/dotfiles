#!/bin/bash

set -euxo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd -P)

# If the Emacs configuration directory already exists, refuse to remove it.
if [ -d ~/.emacs.d ] && [ ! -h ~/.emacs.d ]; then
	echo "~/.emacs.d already exists and not a link. Refusing to overwrite"
	echo "  Consider backing up with 'mv ~/.emacs.d ~/.emacs.d'"
	exit 1
fi
# But if it's just a file or a link, clean it up and remove it.
if [ -f ~/.emacs.d ] || [ -h ~/.emacs.d ]; then
	rm ~/.emacs.d
fi

# Restore the backup, if it exists.
if [ -d ~/.emacs.d.bak ]; then
	mv ~/.emacs.d.bak ~/.emacs.d
else
	ln -s -f "$CONFIG_DIR/emacs.d" ~/.emacs.d
fi
