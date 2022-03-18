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
setopt PROMPT_SUBST
PROMPT='%F{green}%n%f@%F{39}%m%f:%F{yellow}%~%f %F{cyan}$git_branch%f
%F{214}λ%f '

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
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

### User configuration ###
export TERM=xterm-256color
export CLICOLOR=1
export EDITOR="emacsclient --alternate-editor='' --create-frame"
export PAGER='less'

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
    ;;
    FreeBSD)
	# do nothing
    ;;
esac

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

