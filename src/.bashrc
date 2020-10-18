#!/usr/bin/env bash
#
# Save 5,000 lines of history in memory
HISTSIZE=10000
# Save 2,000,000 lines of history to disk (will have to grep ~/.bash_history for full listing)
HISTFILESIZE=2000000
# Append to history instead of overwrite
shopt -s histappend
# Ignore redundant or space commands
HISTCONTROL=ignoreboth
# Ignore more
HISTIGNORE='l:ls:ll:ls -alh:pwd:clear:history'
# Set time format
HISTTIMEFORMAT='%F %T '
# Multiple commands on one line show up as a single line
shopt -s cmdhist

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

eval "$(starship init bash)"

# Load shell aliases
source $HOME/.shell/alias.sh

# Load shell functions
source $HOME/.shell/functions.sh

# Set colors for ls directories and files
eval $(dircolors -b)

[ -f "$HOME/.fzf.zsh" ] && source $HOME/.fzf.zsh;
export TERM=xterm-256color

complete -C /home/audron/.local/bin/terraform terraform
