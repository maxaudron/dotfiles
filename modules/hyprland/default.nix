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
    grim
    slurp
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

  xdg.configFile = {
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    "wayprompt/config.ini".text = lib.generators.toINI { } {
      general = {
        border = "2;";
        corner-radius = "15;";
      };

      colours = rec {
        background = "0x1e1e2e;";
        border = "0xcba6f7;";
        text = "0xcdd6f4;";
        error-text = "0xf38ba8;";
        pin-background = "0x181825;";
        pin-border = border;
        pin-square = text;
        ok-button = "0xa6e3a1;";
        ok-button-border = ok-button;
        ok-button-text = "0x313244;";
        not-ok-button = "0xf38ba8;";
        not-ok-button-border = not-ok-button;
        not-ok-button-text = ok-button-text;
        cancel-button = "0xfab387;";
        cancel-button-border = cancel-button;
        cancel-button-text = ok-button-text;
      };
    };
  };
}
