{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    alacritty
    waybar
    seatd

    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    rofi-wayland

    xdotool
  ];

  xdg = {
    enable = true;
    configFile = { "hypr/hyprland.conf" = { source = ./hyprland.conf; }; };
  };
}
