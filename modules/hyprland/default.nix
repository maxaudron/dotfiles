{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprpaper
    ./quickshell
    # ./mako

    ./settings.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    seatd

    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    qt6.qtwayland
    libsForQt5.qt5.qtwayland

    pkgs.unstable.quickshell
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # package = pkgs.unstable.hyprland;
    # portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    package = null;
    portalPackage = null;

    plugins = with pkgs.unstable.hyprlandPlugins; [
      hy3
      hyprsplit
    ];

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

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
