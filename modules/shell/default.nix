{ config, pkgs, lib, builtins, ... }:

let
  aliases = {
    # terraform
    tf = "terraform";
    tfi = "terraform init -upgrade";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfd = "terraform destroy";

    # git
    ga = "git add";
    gc = "git commit -v";
    glg = "git glog";
    gp = "git push";

    # systemctl
    sys = "systemctl";
    sysu = "systemctl --user";

    # misc
    cl = "clear";
    kc = "kubectl";
    nmpc = "ncmpcpp";
    ec = "emacsclient -nc";
    hi = "ack --passthru";

    l = "exa -al --git --group-directories-first --time-style=long-iso";
    lg = "exa -al --group-directories-first --git --time-style=long-iso";
    "l." =
      "exa -al --git --group-directories-first --time-style=long-iso -F -I '[!^.]*'";
    lt =
      "exa -al --git --group-directories-first --time-style=long-iso -I .git --tree";
  };

in {
  imports = [ ./powerlevel10k.nix ./functions.nix ];

  home.packages = with pkgs; [ fzf exa ];

  home.shellAliases = aliases;

  programs.bash = {
    enable = true;
    shellAliases = aliases;

    initExtra = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    '';
  };

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";

    plugins = [{
      name = "fzf";
      file = "share/fzf/key-bindings.zsh";
      src = pkgs.fzf;
    }];

    dotDir = ".config/zsh";
    history = {
      size = 5000;
      save = 10000;
      path = "${config.home.homeDirectory}/.config/.zsh/.zsh_history";
    };

    completionInit = ''
      autoload -U compinit && compinit
      autoload -U +X bashcompinit && bashcompinit
    '';

    initExtra = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search # Up
      bindkey "^[[B" down-line-or-beginning-search # Down

      bindkey -- "^[[H" beginning-of-line
      bindkey -- "^[[F" end-of-line
    '';
  };
}
