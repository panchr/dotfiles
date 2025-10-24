#!/bin/bash
#
# init.sh sets up configuration. Packages should be installed first, using
# install-packages.sh.
#
# Note the script may need to be run twice, once zshenv and zshrc are setup.

set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$(realpath "$SCRIPT_DIR/..")

git -C "$CONFIG_DIR" submodule init
git -C "$CONFIG_DIR" submodule update

# Dotfiles are symlinked so they are kept up-to-date when the repository is
# pulled.
ln -s -f "$CONFIG_DIR/zsh/sh_functions" ~/.sh_functions
ln -s -f "$CONFIG_DIR/zsh/zshenv" ~/.zshenv
ln -s -f "$CONFIG_DIR/zsh/zshrc" ~/.zshrc

# Setup tmux and tpm.
ln -s -f "$CONFIG_DIR/tmux/tmux.conf" ~/.tmux.conf

# If the tpm symlink already exists, clean it up.
if [ ! -d ~/.tmux/plugins/tpm ]; then
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
fi
~/.tmux/plugins/tpm/bin/clean_plugins

# Configure git.
git config set --global --all --fixed-value --value="$CONFIG_DIR/git/gitconfig" include.path "$CONFIG_DIR/git/gitconfig"
if command -v riff >/dev/null; then
    # Configure the 'riff' git differ.
    # See: https://github.com/walles/riff.
    git config set --global --all --fixed-value --value="$CONFIG_DIR/git/diffconfig" include.path "$CONFIG_DIR/git/diffconfig"
fi

# Claude settings.
mkdir -p ~/.claude
mkdir -p ~/.claude/commands
ln -s -f "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -s -f "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -s -f "$CONFIG_DIR/claude/commands/address-comments.md" ~/.claude/commands/address-comments.md

# Configure ghostty.
if [ ! -L ~/.config/ghostty ]; then
    ln -s -f "$CONFIG_DIR/ghostty" ~/.config/ghostty
fi

# Mise (environment management).
if [ ! -L ~/.config/mise ]; then
    mise trust "$CONFIG_DIR/mise/config.toml"
    ln -s -f "$CONFIG_DIR/mise" ~/.config/mise
fi
mise install

readonly INIT_DOOM="${INIT_DOOM:-1}"
if [ "$INIT_DOOM" = "1" ]; then
    $SCRIPT_DIR/init-doom.sh
fi
