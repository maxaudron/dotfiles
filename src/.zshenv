###############################################################################
# Settings
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"
export PATH="/usr/sbin:$HOME/go/bin:/nix/var/nix/profiles/per-user/$USER/profile/bin/:$HOME/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/musl/bin:$PATH"
export GOPATH="$HOME/go/"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export HELMFILE_HELM3=1
