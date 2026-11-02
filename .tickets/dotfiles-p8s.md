---
id: dotfiles-p8s
status: closed
deps: []
links: []
created: 2026-09-14T22:14:45Z
type: task
priority: 2
assignee: Rushy Panchal
---
# zsh: cut interactive startup on macOS from ~36ms toward ~10ms

bench.sh reports ~36ms on macOS with /bin/zsh (the ~10ms in 9c053d6 was measured on Linux). Causes found: /etc/zprofile+/etc/zshrc cost ~7ms (path_helper and locale forks, terminfo); compinit ~4.5ms before anything needs it; .zwc caches compiled by Homebrew zsh 5.9.2 are silently rejected by /bin/zsh 5.9 (and vice versa), so sources were being parsed; fzf and Ghostty integration parsed at startup; precmd fc -R re-appends the whole history file every prompt.

## Notes

**2026-09-14T22:45:37Z**

Closed: zshrc/zshenv/bench.sh reworked: no_global_rcs with fork-free PATH, version-checked .zwc caches, lazy compinit on first Tab, fzf deferred to the zle idle hook, compiled Ghostty integration, native SHARE_HISTORY instead of per-prompt fc -R, mtime-gated rehash. bench.sh (/bin/zsh): 36ms -> ~17ms; pty first prompt 22 -> 13ms, first command done 77 -> 59ms. Remaining cost is p10k (instant prompt + gitstatus daemon + first-precmd init) and the process floor.
