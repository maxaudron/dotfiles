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

  home.packages = with pkgs; [ fzf exa tmux tmux-cssh ];

  home.shellAliases = aliases;

  # home.sessionVariables = {
  #   EDITOR = "emacsclient -c";
  #   VISUAL = "emacsclient -c";
  # };

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
    defaultKeymap = "viins";

    plugins = [
      {
        name = "fzf";
        file = "share/fzf/key-bindings.zsh";
        src = pkgs.fzf;
      }
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "ef8ba84c3a76c768f49a0bdd2a620b2f53c2478a";
          hash = "sha256:058s55r8gq1giwnb2si8k38nvd0qy8jlhd9zhvsxyl0mvi7wk9ar";
        };
      }
    ];

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

    initExtra = lib.readFile ./zshrc;
  };
}
