#!/bin/bash
#
# init.sh sets up configuration. Packages should be installed first, using
# install-packages.sh.
#
# Note the script may need to be run twice, once zshenv and zshrc are setup.

set -euxo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd -P)

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

# Configure ghostty.
mkdir -p ~/.config
if [ ! -L ~/.config/ghostty ]; then
	ln -s -f "$CONFIG_DIR/ghostty" ~/.config/ghostty
fi

# Claude.
mkdir -p ~/.claude
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
ln -s -f "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -s -f "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
for file in "$CONFIG_DIR/claude/commands/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.claude/commands/
done
for file in "$CONFIG_DIR/claude/agents/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.claude/agents/
done

# Prevent Claude from prompting on basic settings.
if [ -f ~/.claude.json ]; then
	jq '.theme = "dark" | .hasCompletedOnboarding = true' ~/.claude.json >~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json
else
	echo '{"theme": "dark", "hasCompletedOnboarding": true}' >~/.claude.json
fi

# Codex.
mkdir -p ~/.codex
ln -s -f "$CONFIG_DIR/codex/settings.toml" ~/.codex/config.toml

# OpenCode.
mkdir -p ~/.config/opencode
mkdir -p ~/.config/opencode/agent
mkdir -p ~/.config/opencode/guidelines
mkdir -p ~/.config/opencode/plugin
mkdir -p ~/.config/opencode/command
ln -s -f "$CONFIG_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -s -f "$CONFIG_DIR/opencode/AGENTS.md" ~/.config/opencode/AGENTS.md
for file in "$CONFIG_DIR/opencode/agent/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/agent/
done
for file in "$CONFIG_DIR/opencode/guidelines/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/guidelines/
done
for file in "$CONFIG_DIR/opencode/plugin/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/plugin/
done
for file in "$CONFIG_DIR/opencode/command/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/command/
done

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

# Configure git.
# TODO(rushy_panchal): This fails when PATH does not properly point to Homebrew, because it
# relies on a newer version of Git than MacOS installs.
git config set --global --all --fixed-value --value="$CONFIG_DIR/git/gitconfig" include.path "$CONFIG_DIR/git/gitconfig"
if command -v riff >/dev/null; then
	# Configure the 'riff' git differ.
	# See: https://github.com/walles/riff.
	git config set --global --all --fixed-value --value="$CONFIG_DIR/git/diffconfig" include.path "$CONFIG_DIR/git/diffconfig"
fi
