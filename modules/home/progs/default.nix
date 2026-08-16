{ lib, ... }:

with lib;
{
  imports = [
    ./firefox
    ./kicad
    ./mc
    ./obs
    ./weechat

    ./darktable.nix
    ./pass.nix
    ./kanidm.nix
    ./mail.nix
    ./opencode.nix
  ];

  config.my.progs = {
    firefox.enable = mkDefault false;
    weechat.enable = mkDefault false;
    mc.enable = mkDefault true;
    pass.enable = mkDefault true;
    kanidm.enable = mkDefault true;
  };
}
