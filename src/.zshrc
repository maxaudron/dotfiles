#!/bin/zsh
[ -f "$HOME/.fzf.zsh" ] && source $HOME/.fzf.zsh;

(source <(kubectl completion zsh) &) &> /dev/null


source $HOME/.zsh/lib/completion.zsh
source $HOME/.zsh/plugins/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/plugins/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $HOME/.zsh/plugins/zsh-users/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

# Load Shell theme
source $HOME/.zsh/powerlevel.zsh
# source $HOME/.zsh/powerline.zsh

# Load shell aliases
source $HOME/.shell/alias.sh

# Load shell functions
source $HOME/.shell/functions.sh
