# Don't execute this file when running in a pure nix-shell.
if test -n "$IN_NIX_SHELL"; then return; fi

if [ -z "$__NIX_DARWIN_SET_ENVIRONMENT_DONE" ]; then
  . /nix/store/9awhps0n8kzvacmrbwxqyq9x9pyw2zg1-set-environment
fi

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
