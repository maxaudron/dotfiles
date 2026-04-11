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
  ];

  config.my.progs = {
    firefox.enable = mkDefault true;
    weechat.enable = mkDefault false;
    mc.enable = mkDefault true;
    pass.enable = mkDefault true;
  };
}
