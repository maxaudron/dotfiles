{ config, lib, pkgs, hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
    ./hyprpaper
  ];

  home.packages = with pkgs; [
    wl-clipboard
    alacritty
    seatd

    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = lib.readFile ./hyprland.conf;
    systemdIntegration = true;
    xwayland = {
      enable = true;
    };
  };
}
