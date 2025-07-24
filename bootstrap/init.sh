#!/bin/bash

set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$(realpath "$SCRIPT_DIR/..")

# Dotfiles are symlinked so they are kept up-to-date when the repository is
# pulled.
ln -s -f "$CONFIG_DIR/.sh_functions" ~/.sh_functions
ln -s -f "$CONFIG_DIR/.zshrc" ~/.zshrc
ln -s -f "$CONFIG_DIR/.tmux.conf" ~/.tmux.conf
ln -s -f "$CONFIG_DIR/emacs.d" ~/.emacs.d

# Claude settings.
mkdir -p ~/.claude
ln -s -f "$CONFIG_DIR/.claude/settings.json" ~/.claude/settings.json
ln -s -f "$CONFIG_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
