# Rushy Panchal
# zsh configuration

if (( ${+ZSH_PROFILE_STARTUP} )); then
	zmodload zsh/zprof
fi

### Prompt ###
# Run before prompt is printed
precmd() {
    find_git_branch;
}

autoload -U colors
autoload -Uz promptinit
setopt PROMPT_SUBST
PROMPT_CHAR="λ"
PROMPT='%F{39}%m%f:%F{yellow}%~%f %F{cyan}$git_branch%f
%F{214}$PROMPT_CHAR%f '

### Completions ###
autoload -U compinit

# Only load compinit once per day, see
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206.
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

# menu-style completion
zstyle ':completion:*' menu select

# Emacs-style key bindings
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# search forwards/backwards in history
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_SAVE_NO_DUPS	  # do not save duplicated commands in HISTFILE
setopt HIST_REDUCE_BLANKS     # remove superfluous blanks from each command
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt APPEND_HISTORY 	      # append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY     # add commands to HISTFILE immediately in order of execution
setopt SHARE_HISTORY          # share command history data

### User configuration ###
export TERM=xterm-256color
export CLICOLOR=1
export EDITOR="emacsclient --alternate-editor='' --create-frame -nw"
export PAGER='less -R'

# Increase max open files limit. On MacOS, this defaults to 256, which is very
# limiting.
ulimit -S -n 2048

# Functions
zcompile ~/.sh_functions
source ~/.sh_functions

# Aliases
alias grep='grep --color=auto'
alias edit="$EDITOR"
alias python='python3'

case `uname` in
    Darwin)
	alias  ls='ls -G'
	export LSCOLORS=HxfxBxdx
	export PATH=/opt/homebrew/bin:$PATH

    export DOTFILES="$(dirname "$(readlink "$0")")"
    ;;
    Linux)
	alias ls='ls --color=auto'
	export LS_COLORS='no=00;36:di=01;37:ex=01;31:ln=00;35'
	export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
	export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
	export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
	export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
	export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
	export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
	export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
	export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

    export DOTFILES="$(cd $(dirname $([ -L $0 ] && readlink -f $0 || echo $0)))"
    ;;
    FreeBSD)
	# do nothing
    ;;
esac

# Configure Docker Desktop.
if [ -f ~/.docker/init-zsh.sh ]; then
	source ~/.docker/init-zsh.sh || true
fi

# Environment variables
if [ -f ~/.env_variables ]; then
    source ~/.env_variables
fi

# Local Configuration
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

if (( ${+ZSH_PROFILE_STARTUP} )); then
	zprof
fi

# iterm2 integration.
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Prevent applications from messing up my terminal character. This resets
# the character to a |.
printf '\e[6 q'
