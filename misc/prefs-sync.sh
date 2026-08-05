#!/bin/sh
# Keep macOS preference domains in sync between this repo and cfprefsd.
#
# The repo copies cannot simply be symlinked into ~/Library/Preferences: cfprefsd
# owns those files and rewrites them by atomic rename, which replaces a symlink
# with a regular file the first time settings change in the app's UI. Going
# through `defaults` instead reads the daemon's live state, so UI changes are
# picked up immediately rather than whenever the daemon happens to flush to disk.
#
# Usage:
#   prefs-sync.sh export       mirror live preferences into the repo (default)
#   prefs-sync.sh import       load the repo's copies into cfprefsd
#   prefs-sync.sh watch-paths  print the preference files a watcher should follow
#
# This list is the single source of truth: bootstrap/init.sh builds the launch
# agent's WatchPaths from it, so adding an app here is the only change needed.
# Each entry is "<repo plist basename>:<preferences domain>".
set -eu

readonly DOMAINS="
rectangle:com.knollsoft.Rectangle
stats:eu.exelban.Stats
"

MISC_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly MISC_DIR

export_all() {
	# Assigned before `readonly` so a failing mktemp trips `set -e`; the exit
	# status of a `readonly` builtin masks the command substitution's.
	tmp="$(mktemp)"
	trap 'rm -f "$tmp"' EXIT

	for entry in $DOMAINS; do
		domain="${entry#*:}"
		dest="$MISC_DIR/${entry%%:*}.plist"

		# The two-argument form of `defaults export` exits 0 while writing
		# nothing on recent macOS; the stdout form is the one that works.
		defaults export "$domain" - >"$tmp"

		# An uninstalled or not-yet-launched app exports an empty dict, which
		# would otherwise wipe the checked-in settings on a fresh machine.
		grep -q '<key>' "$tmp" || continue

		# Avoid touching mtime when nothing changed, so the repo stays quiet.
		cmp -s "$tmp" "$dest" || cp -f "$tmp" "$dest"
	done
}

import_all() {
	for entry in $DOMAINS; do
		defaults import "${entry#*:}" "$MISC_DIR/${entry%%:*}.plist"
	done
}

watch_paths() {
	for entry in $DOMAINS; do
		echo "$HOME/Library/Preferences/${entry#*:}.plist"
	done
}

case "${1:-export}" in
export) export_all ;;
import) import_all ;;
watch-paths) watch_paths ;;
*)
	echo "usage: $(basename "$0") [export|import|watch-paths]" >&2
	exit 2
	;;
esac
