#!/bin/bash
#
# init.sh sets up configuration. Packages should be installed first, using
# install-packages.sh.
#
# Note the script may need to be run twice, once zshenv and zshrc are setup.

set -euxo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd -P)

"$SCRIPT_DIR/install-packages.sh"

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
mkdir -p ~/.claude/guidelines
ln -s -f "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -s -f "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -s -f "$CONFIG_DIR/claude/statusline.sh" ~/.claude/statusline.sh
for file in "$CONFIG_DIR/claude/commands/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.claude/commands/
done
for file in "$CONFIG_DIR/claude/agents/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.claude/agents/
done
for file in "$CONFIG_DIR/claude/guidelines/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.claude/guidelines/
done

# Prevent Claude from prompting on basic settings.
if [ -f ~/.claude.json ]; then
	jq '.theme = "dark" | .hasCompletedOnboarding = true' ~/.claude.json >~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json
else
	echo '{"theme": "dark", "hasCompletedOnboarding": true}' >~/.claude.json
fi

# OpenCode.
mkdir -p ~/.config/opencode
mkdir -p ~/.config/opencode/agent
mkdir -p ~/.config/opencode/guidelines
mkdir -p ~/.config/opencode/plugin
mkdir -p ~/.config/opencode/command
ln -s -f "$CONFIG_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -s -f "$CONFIG_DIR/claude/CLAUDE.md" ~/.config/opencode/AGENTS.md
for file in "$CONFIG_DIR/opencode/agent/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/agent/
done
for file in "$CONFIG_DIR/claude/guidelines/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/guidelines/
done
for file in "$CONFIG_DIR/opencode/plugin/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/plugin/
done
for file in "$CONFIG_DIR/opencode/command/"*; do
	[ -f "$file" ] && ln -s -f "$file" ~/.config/opencode/command/
done

# btop (system monitor).
mkdir -p ~/.config/btop
ln -s -f "$CONFIG_DIR/misc/btop.conf" ~/.config/btop/btop.conf

# Menubar app preferences (Rectangle for window management, Stats for system
# monitoring). These are imported rather than symlinked because cfprefsd replaces
# its plists by atomic rename, which would clobber a link. A single agent watches
# every domain and mirrors UI changes back into the repo to close that gap. The
# app list lives in prefs-sync.sh.
readonly PREFS_SYNC="$CONFIG_DIR/misc/prefs-sync.sh"
"$PREFS_SYNC" import

mkdir -p ~/Library/LaunchAgents
readonly PREFS_AGENT=~/Library/LaunchAgents/com.panchr.prefs-sync.plist
# The watch paths are spliced in with `r` because a sed replacement cannot span
# newlines; `d` then drops the placeholder line itself.
sed -e "/__WATCH_PATHS__/r "<("$PREFS_SYNC" watch-paths | sed -e 's|.*|\t\t<string>&</string>|') \
	-e "/__WATCH_PATHS__/d" \
	-e "s|__CONFIG_DIR__|$CONFIG_DIR|g" \
	"$CONFIG_DIR/misc/prefs-sync.plist" >"$PREFS_AGENT"
launchctl unload "$PREFS_AGENT" 2>/dev/null || true
launchctl load "$PREFS_AGENT"

# Mise (environment management).
mkdir -p ~/.config/mise
ln -s -f "$CONFIG_DIR/misc/mise.toml" ~/.config/mise/config.toml
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
