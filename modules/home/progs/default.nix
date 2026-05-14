{ lib, ... }:

with lib;
{
  imports = [
    ./firefox
    ./kicad
    ./mc
    ./obs
    ./weechat

    ./pass.nix
    ./kanidm.nix
  ];

  config.my.progs = {
    firefox.enable = mkDefault false;
    weechat.enable = mkDefault false;
    mc.enable = mkDefault true;
    pass.enable = mkDefault true;
    kanidm.enable = mkDefault true;
  };
}
