# Rushy Panchal
# zsh configuration

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
compinit

# menu-style completion
zstyle ':completion:*' menu select

# Emacs-style key bindings
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

### User configuration ###
if [ -n "${TMUX+1}" ]; then
    export TERM=tmux-256color
else
    export TERM=xterm-256color
fi
export CLICOLOR=1
export EDITOR="emacsclient --alternate-editor='' --create-frame"
export PAGER='less'

# Functions
zcompile ~/.sh_functions
source ~/.sh_functions

# Aliases
alias grep='grep --color=auto'
alias edit="$EDITOR"

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
