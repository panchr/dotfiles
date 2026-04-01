#!/bin/bash

set -euxo pipefail

# Pinned Doom Emacs version (commit hash from doomemacs/doomemacs).
DOOM_PIN="d8d7544"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd -P)

# Uninstall any old Emacs configuration, by moving it elsewhere. If it's a link,
# just remove it.
if [ -d ~/.emacs.d ] && [ ! -h ~/.emacs.d ]; then
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

# Link the configuration. This must be done before the Doom install so extra
# packages are not installed.
ln -s -f "$CONFIG_DIR/doom" ~/.config/doom

# Install Doom if it does not exist.
if [ ! -d ~/.config/emacs ]; then
	echo "Installing Doom (pinned to $DOOM_PIN)"
	git clone https://github.com/doomemacs/doomemacs ~/.config/emacs
	git -C ~/.config/emacs checkout "$DOOM_PIN"
	~/.config/emacs/bin/doom install --no-env
fi

~/.config/emacs/bin/doom sync -!

# On macOS, disable the "Input Sources" keyboard shortcuts (Select the previous
# input source / Select next source in Input menu) so Ctrl+Space reaches
# terminal Emacs as set-mark instead of being swallowed by the OS.
# The XML plist form is required because the old-style form writes strings
# instead of bool/int, and the hotkey daemon ignores it.
if [[ "$(uname)" == "Darwin" ]]; then
	defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
		-dict-add 60 \
		'<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'
	defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
		-dict-add 61 \
		'<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>786432</integer></array><key>type</key><string>standard</string></dict></dict>'
	/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
fi
