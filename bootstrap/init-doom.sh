#!/bin/bash

set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$(realpath "$SCRIPT_DIR/..")

# Uninstall any old Emacs configuration, by moving it elsewhere. If it's a link,
# just remove it.
if [ -d ~/.emacs.d ] [ ! -h ~/.emacs.d ]; then
    mv ~/.emacs.d ~/.emacs.d.bak
fi
if [ -f ~/.emacs.d ] || [ -h ~/.emacs.d ]; then
    rm ~/.emacs.d
fi
mkdir -p ~/.config/

# If the Doom configuration directory already exists, refuse to remove it.
if [ -d ~/.config/doom ] && [ ! -h ~/.config/doom ]; then
   echo "~/.config/doom already exists and not a link. Refusing to overwrite"
   echo "  Consider backing up with 'mv ~/.config/doom ~/.config/doom.bak'"
   exit 1
fi
# But if it's just a file or a link, clean it up and remove it.
if [ -f ~/.config/doom ] || [ -h ~/.config/doom ]; then
    rm ~/.config/doom
fi

# Install Doom if it does not exist.
if [ ! -d ~/.config/emacs ]; then
    echo "Installing Doom"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install --aot --no-env
fi

# And finally, link the configuration.
ln -s -f "$CONFIG_DIR/doom" ~/.config/doom
~/.config/emacs/bin/doom sync
