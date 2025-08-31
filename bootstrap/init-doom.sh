#!/usr/bin/env sh

set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$(realpath "$SCRIPT_DIR/..")

rm -rf ~/.emacs.d
mkdir -p ~/.config/

if [ ! -d "~/.config/emacs" ]; then
    echo "Installing Doom"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs && ~/.config/emacs/bin/doom install
fi

ln -s -f "$CONFIG_DIR/doom" ~/.config/doom
~/.config/emacs/bin/doom sync
