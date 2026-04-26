#!/bin/bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // null')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

display_dir="$cwd"
if [[ "$cwd" == "$HOME"* ]]; then
  display_dir="~${cwd#$HOME}"
fi

printf "[\033[38;5;81m%s\033[0m" "$model"

if [ "$used" = "null" ] || [ -z "$used" ]; then
  used_int=0
else
  used_int=$(printf "%.0f" "$used")
fi

bar_width=15
filled=$(( used_int * bar_width / 100 ))
empty=$(( bar_width - filled ))

printf " \033[38;5;39m"
for ((i=0; i<filled; i++)); do printf "━"; done
printf "\033[38;5;240m"
for ((i=0; i<empty; i++)); do printf "─"; done
printf "\033[0m"

if [ "$used_int" -ge 70 ]; then
  pct_color="\033[38;5;1m"
elif [ "$used_int" -ge 50 ]; then
  pct_color="\033[38;5;208m"
else
  pct_color=""
fi

printf " %b%d%%\033[0m" "$pct_color" "$used_int"
printf "]"

if [ -n "$display_dir" ]; then
  printf " \033[38;5;220m%s\033[0m" "$display_dir"
fi
