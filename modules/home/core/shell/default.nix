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
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

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
