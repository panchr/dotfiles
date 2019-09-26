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

### User configuration ###
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=HxfxBxdx
export EDITOR="emacsclient --alternate-editor=''"

# Functions
zcompile ~/.sh_functions
source ~/.sh_functions

# Aliases
alias grep='grep --color=always'
alias edit="$EDITOR"

# Environment variables
if [ -f ~/.env_variables ]; then
    source ~/.env_variables
fi

### Completions ###
autoload -U compinit
compinit

# menu-style completion
zstyle ':completion:*' menu select
