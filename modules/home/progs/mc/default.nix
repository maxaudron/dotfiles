{
  config,
  lib,
  pkgs,
  ...
}:

let
  catppuccin = fetchGit {
    url = "https://github.com/catppuccin/mc";
    rev = "f1c78f183764cd43e6dd4e325513ef5547a8f28f";
  };
in
{
  options.my.progs.mc = {
    enable = lib.mkEnableOption "mc";
  };

  config = lib.mkIf config.my.progs.mc.enable {
    home.packages = [ pkgs.mc ];

    xdg.dataFile."mc/skins/catppuccin.ini".source = "${catppuccin}/catppuccin.ini";

    xdg.configFile."mc/ini".text = lib.generators.toINI { } {
      "Midnight-Commander" = {
        skin = "catppuccin";
      };
    };
  };
}
