#!/bin/bash
#
# macos.sh configures macOS system preferences: keyboard mappings, trackpad,
# mouse, Finder, and Dock settings.
#
# This only runs on macOS.

set -euxo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
	echo "macos.sh: skipping, not macOS" >&2
	exit 0
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "macos.sh: must be run as root (sudo)" >&2
	exit 1
fi

# Close System Settings to prevent it from overriding changes.
osascript -e 'tell application "System Settings" to quit'

# --- Appearance ---

# Dark mode.
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# --- Keyboard ---

# Apple's vendor ID is always 1452 (0x05AC).
readonly VENDOR_ID=1452

# Discover the built-in keyboard's ProductID.
PRODUCT_ID=$(hidutil list | grep -i "Apple Internal Keyboard" | awk '{print $2}' | head -1)
if [[ -z "$PRODUCT_ID" ]]; then
	echo "macos.sh: could not find built-in Apple keyboard" >&2
	exit 1
fi
# Convert from hex to decimal.
PRODUCT_ID=$((PRODUCT_ID))
readonly PRODUCT_ID

readonly KEY="${VENDOR_ID}-${PRODUCT_ID}-0"

# HID usage codes (decimal):
#   Caps Lock:      30064771129  (0x700000039)
#   Left Control:   30064771296  (0x7000000E0)
#   Right Control:  30064771300  (0x7000000E4)
#   Disabled:       30064771072  (0x700000000)
#
# Caps Lock → Right Control, both Controls → disabled.
#
# Requires logout/reboot to take effect.
defaults -currentHost write -g \
	"com.apple.keyboard.modifiermapping.${KEY}" -array \
	'<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771296</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771072</integer></dict>' \
	'<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer></dict>' \
	'<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771300</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771072</integer></dict>'

# Fast key repeat rate.
defaults write NSGlobalDomain KeyRepeat -int 2
# Short delay before key repeat starts.
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --- Mouse & Trackpad ---

# Mouse tracking speed.
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.5
# Light click threshold for trackpad.
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0

# --- Finder ---

# Show file extensions for all files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show full path breadcrumb bar at bottom.
defaults write com.apple.finder ShowPathbar -bool true
# Show item count and disk space at bottom.
defaults write com.apple.finder ShowStatusBar -bool true
# Default to list view.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Search the current folder by default (not entire Mac).
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Hide all drives and mounts from desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
killall Finder

# --- Dock ---

# Position dock on the right side of the screen.
defaults write com.apple.dock orientation -string "right"
# Small icon size.
defaults write com.apple.dock tilesize -int 33
# Keep dock always visible.
defaults write com.apple.dock autohide -bool false
# Disable icon magnification on hover.
defaults write com.apple.dock magnification -bool false
# Minimize windows into their app icon.
defaults write com.apple.dock minimize-to-application -bool true
# Bounce icon when launching an app.
defaults write com.apple.dock launchanim -bool true
# Show dot indicator under running apps.
defaults write com.apple.dock show-process-indicators -bool true
# Hide "Recent Applications" section.
defaults write com.apple.dock show-recents -bool false
# Don't auto-rearrange Spaces based on most recent use.
defaults write com.apple.dock mru-spaces -bool false
# Group windows by app in Mission Control.
defaults write com.apple.dock expose-group-apps -bool true
# Use scale effect for window minimization.
defaults write com.apple.dock mineffect -string "scale"
killall Dock

# --- Desktop Services ---

# Avoid creating .DS_Store files on network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Prevent Photos from opening automatically when devices are plugged in.
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# --- Power Management ---

# Disable Power Nap (background sync while sleeping).
pmset -a powernap 0
# System sleep after 5 minutes.
pmset -a sleep 5
# Display sleep after 5 minutes.
pmset -a displaysleep 5

# --- Menu Bar ---

# Show seconds in clock.
defaults write com.apple.menuextra.clock ShowSeconds -bool true
# Show Bluetooth in menu bar.
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Bluetooth" -bool true
# Show volume in menu bar.
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Sound" -bool true
# Hide user switcher from menu bar.
defaults write com.apple.controlcenter "NSStatusItem VisibleCC UserSwitcher" -bool false
# Show battery percentage (must run as the user, not root).
sudo -u "$SUDO_USER" defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -int 1
killall ControlCenter

# --- Screen Saver ---

# Require password immediately after screensaver activates.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "macos.sh: configured macOS preferences"
