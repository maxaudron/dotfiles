{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.my.desktop.enable {
    my.desktop.wayprompt.enable = lib.mkDefault true;

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
    ];

    services.gnome-keyring.enable = true;

    home.sessionVariables = {
      WLR_RENDERER = "vulkan";
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

    xdg.configFile = {
      "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
  };
}
