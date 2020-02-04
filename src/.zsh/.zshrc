#!/bin/zsh
# Load Shell theme
source $HOME/.zsh/powerlevel.zsh
# source $HOME/.zsh/powerline.zsh

#source $HOME/.zsh/lib/completion.zsh
source $HOME/.zsh/plugins/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/plugins/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

source $HOME/.zsh/history.zsh

# Load shell aliases
source $HOME/.shell/alias.sh

# Load shell functions
source $HOME/.shell/functions.sh

# Set colors for ls directories and files
eval $(dircolors -b)


fpath=($HOME/.zsh/plugins/zsh-users/zsh-completions/src $fpath)
autoload -U compinit
compinit

[ -f "$HOME/.fzf.zsh" ] && source $HOME/.fzf.zsh;
