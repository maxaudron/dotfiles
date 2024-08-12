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
    sys = "sudo systemctl";
    sysu = "systemctl --user";

    # misc
    cl = "clear";
    kc = "kubectl";
    nmpc = "ncmpcpp";
    ec = "emacsclient -nc";
    hi = "ack --passthru";

    l = "eza -al --git --group-directories-first --time-style=long-iso";
    lg = "eza -al --group-directories-first --git --time-style=long-iso";
    "l." =
      "eza -al --git --group-directories-first --time-style=long-iso -F -I '[!^.]*'";
    lt =
      "eza -al --git --group-directories-first --time-style=long-iso -I .git --tree";

    z = "${pkgs.unstable.zed-editor}/bin/zed";
  };

in
{
  imports = [ ./powerlevel10k.nix ./functions.nix ];

  home.packages = with pkgs; [ fzf eza tmux tmux-cssh ack ];

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

    autosuggestion.enable = true;
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

    completionInit = lib.readFile ./completion.zsh;

    initExtra = lib.readFile ./zshrc;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # Hydro
      set --global hydro_symbol_prompt ❱
      set --global hydro_color_pwd 'cba6f7'
      set --global hydro_color_prompt 'cba6f7'

      set --global LS_COLORS '${builtins.readFile ./ls_colors}'

      set --global SSH_AUTH_SOCK {$HOME}/.gnupg/S.gpg-agent.ssh

      set --global --export KUBECONFIG "$HOME/.kube/config:$(find ~/.kube/configs -type f | paste -sd ':' - )"
    '';
    plugins = [
        { name = "hydro"; src = pkgs.unstable.fishPlugins.hydro.src; }
        { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "fish/themes" = {
        source = "${pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "a3b9eb5";
            hash = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
        }}/themes";
      };
    };
  };
}
