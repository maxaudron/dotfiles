{ config, lib, pkgs, hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
    ./hyprpaper
    ./mako
  ];

  home.packages = with pkgs; [
    wl-clipboard
    alacritty
    seatd

    grim
    slurp
    mpv

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
    package = pkgs.hyprland;
    extraConfig = lib.readFile ./hyprland.conf;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
  };

  qt.platformTheme = "gnome";
  gtk = {
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
  };
}
