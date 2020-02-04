#!/usr/bin/env zsh
zmodload zsh/datetime

function preexec() {
  __TIMER=$EPOCHREALTIME
}

function powerline_precmd() {
    local __ERRCODE=$?
    local __DURATION=0

    if [ -n $__TIMER ]; then
    local __ERT=$EPOCHREALTIME
    __DURATION="$(($__ERT - ${__TIMER:-__ERT}))"
    fi

    eval "$($HOME/.local/bin/powerline-go \
        -shell zsh \
        -eval \
        -error $__ERRCODE \
        -duration $__DURATION \
        -colorize-hostname \
        -modules "cwd,venv,perms,git,hg" \
        -modules-right "exit,jobs,duration,host,ssh"
        )"
    unset __TIMER
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
