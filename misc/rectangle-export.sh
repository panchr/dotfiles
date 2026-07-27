#!/bin/sh
# Mirror live Rectangle preferences back into this repo.
#
# The repo copy cannot simply be symlinked into ~/Library/Preferences: cfprefsd
# owns that file and rewrites it by atomic rename, which replaces a symlink with
# a regular file the first time settings change in Rectangle's UI. Going through
# `defaults` instead reads the daemon's live state, so UI changes are picked up
# immediately rather than whenever the daemon happens to flush to disk.
set -eu

readonly DEST="$(cd "$(dirname "$0")" && pwd)/rectangle.plist"
readonly TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# The two-argument form of `defaults export` exits 0 while writing nothing on
# recent macOS; the stdout form is the one that actually works.
defaults export com.knollsoft.Rectangle - >"$TMP"

# An uninstalled or not-yet-launched Rectangle exports an empty dict, which would
# otherwise wipe the checked-in settings on a fresh machine.
grep -q '<key>' "$TMP" || exit 0

# Avoid touching mtime when nothing changed, so the repo stays quiet.
cmp -s "$TMP" "$DEST" || cp -f "$TMP" "$DEST"
