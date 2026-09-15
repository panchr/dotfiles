#!/usr/bin/env zsh
# Benchmarks interactive shell startup by timing `zsh -i -c exit`, which runs
# zshenv and zshrc in full and exits before the first prompt.
#
# The compiled caches zshrc builds (.zwc files, the fzf snippet) are removed
# first so two configs compare fairly; the warmup runs rebuild them, so the
# measurement reflects steady state. Uses hyperfine when installed
# (`brew install hyperfine`), otherwise a plain timing loop.
#
# The shell timed is $SHELL when that is a zsh, since that is what terminals
# launch (/bin/zsh on macOS); `zsh` on PATH may be a different build, such as
# Homebrew's, and the two do not share compiled caches.
#
# Usage: zsh/bench.sh [runs] [zsh]     (default 30 runs, $SHELL)
emulate -L zsh
zmodload zsh/datetime

local runs=${1:-30}
local zsh_bin=$2
if [[ -z $zsh_bin ]]; then
    [[ ${SHELL:t} == zsh ]] && zsh_bin=$SHELL || zsh_bin=zsh
fi
local zsh_dir="${DOTFILES:-${0:A:h:h}}/zsh"

rm -f ~/.zcompdump.zwc ~/.zshrc.zwc ~/.sh_functions.zwc
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
rm -f "$zsh_dir"/p10k.zsh.zwc \
    "$zsh_dir"/zsh-syntax-highlighting/*.zwc(N) \
    "$zsh_dir"/zsh-syntax-highlighting/highlighters/*/*.zwc(N)

print -r -- "shell: $zsh_bin ($($zsh_bin -c 'print $ZSH_VERSION $ZSH_PATCHLEVEL'))"
if (( $+commands[hyperfine] )); then
    exec hyperfine -N --warmup 5 --runs "$runs" "$zsh_bin -i -c exit"
fi

local -a times
local i start
for i in {1..5}; do
    $zsh_bin -i -c exit >/dev/null 2>&1
done
for i in {1..$runs}; do
    start=$EPOCHREALTIME
    $zsh_bin -i -c exit >/dev/null 2>&1
    times+=( $(( (EPOCHREALTIME - start) * 1000 )) )
done
times=( ${(on)times} )
printf 'runs=%d  min=%.1fms  median=%.1fms  max=%.1fms\n' \
    "$runs" "$times[1]" "$times[(runs + 1) / 2]" "$times[-1]"
