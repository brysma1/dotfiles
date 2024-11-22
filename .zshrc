export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

zstyle ':omz:update' mode auto      # update automatically without asking

zstyle ':omz:update' frequency 14

COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(git docker)

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"
export MANPAGER='nvim +Man!'
export EDITOR='nvim'
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Aliases
alias sv="sudo nvim"
alias v="nvim"
alias v.="nvim ."
