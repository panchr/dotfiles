#!/bin/bash

set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR="$SCRIPT_DIR/.."

# Dotfiles are symlinked so they are kept up-to-date when the repository is
# pulled.
ln -s "$CONFIG_DIR/.sh_functions" ~/.sh_functions
ln -s "$CONFIG_DIR/.zshrc" ~/.zshrc
ln -s "$CONFIG_DIR/.tmux.conf" ~/.tmux.conf
ln -s "$CONFIG_DIR/.emacs.d" ~/.emacs.d

# Claude settings.
mkdir -p ~/.claude
ln -s "$CONFIG_DIR/.claude/settings.json" ~/.claude/settings.json
