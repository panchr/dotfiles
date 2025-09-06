#!/bin/bash

set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$(realpath "$SCRIPT_DIR/..")

# Dotfiles are symlinked so they are kept up-to-date when the repository is
# pulled.
ln -s -f "$CONFIG_DIR/.sh_functions" ~/.sh_functions
ln -s -f "$CONFIG_DIR/.zshrc" ~/.zshrc
ln -s -f "$CONFIG_DIR/.tmux.conf" ~/.tmux.conf

# Claude settings.
mkdir -p ~/.claude
mkdir -p ~/.claude/commands
ln -s -f "$CONFIG_DIR/.claude/settings.json" ~/.claude/settings.json
ln -s -f "$CONFIG_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -s -f "$CONFIG_DIR/.claude/commands/address-review.md" ~/.claude/commands/address-review.md

$SCRIPT_DIR/init-doom.sh
