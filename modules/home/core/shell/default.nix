{
  config,
  pkgs,
  lib,
  builtins,
  ...
}:

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
    eza
    tmux-cssh
    ack
  ];

  home.shellAliases = aliases;

  programs.bash = {
    enable = true;
    shellAliases = aliases;
  };

  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # Hydro
      set --global hydro_symbol_prompt '>'

      function pastor -a file
        curl --progress-bar -F "c=@$file" "https://c-v.sh/?token=$(pass show general/c-v.sh | head -n1)"
      end
      
      function screenshot
        grim -g "$(slurp)" - | pastor - | wl-copy
      end

      function nix-prefetch-sri
        nix-prefetch-url "$1" | xargs nix hash to-sri --type sha256
      end
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
