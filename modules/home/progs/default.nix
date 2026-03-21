{ lib, ... }:

with lib;
{
  imports = [
    ./firefox
    ./kicad
    ./mc
    ./obs
    ./weechat
  ];

  config.my.progs = {
    firefox.enable = mkDefault true;
    weechat.enable = mkDefault true;
    mc.enable = mkDefault true;
  };
}
