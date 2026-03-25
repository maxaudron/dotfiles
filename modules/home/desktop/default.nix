{ lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./wayprompt.nix

    ./hyprland
    ./sway

    ./noctalia
    ./waybar
    ./rofi
  ];

  options.my.desktop.enable = lib.mkEnableOption "desktop";
}
