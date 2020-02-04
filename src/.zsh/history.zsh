#!/usr/bin/env zsh

HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh/.zsh_history     #Where to save history to disk
SAVEHIST=10000               #Number of history entries to save to disk
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# save each command's beginning timestamp and the duration to the history file
setopt extended_history
setopt histignorealldups
setopt histignorespace
