{
  config,
  lib,
  pkgs,
  ...
}:

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

  config = lib.mkIf config.my.desktop.enable {
    home.packages = with pkgs; [
      quasselClient

      discord
      unstable.teamspeak6-client
    ];

    my.progs = {
      firefox.enable = lib.mkDefault true;
    };
  };
}
