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

### User configuration ###
export TERM=xterm-256color
export CLICOLOR=1
export EDITOR="emacsclient --alternate-editor=''"

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
