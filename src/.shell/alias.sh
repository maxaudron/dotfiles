#!/usr/bin/env sh

# VIM
if command -v nvim 2>/dev/null 1>/dev/null; then
    alias v="nvim"
elif command -v vim 2>/dev/null 1>/dev/null; then
    alias v="vim"
else
    alias v="vi"
fi

# LS
if command -v exa 2>/dev/null 1>/dev/null; then
    alias l="exa -al --group-directories-first --git --time-style=long-iso"
    alias l.="exa -al --group-directories-first --git --time-style=long-iso -F -I '[!^.]*'"
    alias lt="exa -al --group-directories-first --git --time-style=long-iso -I .git --tree"
else
    alias l="ls -al --color=always --group-directories-first"
fi

# TERRAFORM
alias tf="terraform"
alias tfi="terraform init -upgrade"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"

# GIT
alias ga="git add"
alias gc="git commit -v"
alias glg="git glog"
alias gp="git push"

# SYSTEMCTL
alias sys="systemctl"
alias sysu="systemctl --user"

# MISC
alias cl="clear"
alias gpg="gpg2"
alias kc="kubectl"
alias nmpc="ncmpcpp"
alias ec="emacsclient"
