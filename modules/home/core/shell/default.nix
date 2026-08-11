{ pkgs, ... }:

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
    gp = "git pushall";

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
    "l." = "eza -al --git --group-directories-first --time-style=long-iso -F -I '[!^.]*'";
    lt = "eza -al --git --group-directories-first --time-style=long-iso -I .git --tree";
  };

in
{
  imports = [
    ./functions.nix
  ];

  home.packages = with pkgs; [
    fzf
    tmux-cssh
    ack
  ];

  home.shellAliases = aliases;

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = aliases;
  };

  programs.man = {
    enable = true;
    package = pkgs.mandoc;
    man-db.enable = false;
    mandoc.enable = true;
    generateCaches = true;
  };

  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
    generateCompletions = false;
    interactiveShellInit = ''
      set fish_greeting # Disable greetinga


      if set -q SSH_CONNECTION
        set -l palette \
            89b4fa \
            74c7ec \
            89dceb \
            94e2d5 \
            a6e3a1 \
            f9e2af \
            fab387 \
            eba0ac \
            f38ba8 \
            cba6f7 \
            f5c2e7 \
            babbf1 \
            a6d189 \
            ef9f76 \
            ea999c \
            ca9ee6

        # Hash the hostname, extract a decimal number from the hex digest
        set -l hash_val (echo (hostname) | md5sum | cut -c 1-8)
        set -l index (math "0x$hash_val % "(count $palette))

        set --global hydro_color_pwd $fish_color_host
      end

      # Store the picked color
      set -g fish_color_host $palette[(math $index + 1)]

      # Hydro
      set --global hydro_symbol_prompt '>'
    '';
    plugins = [
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };
}
