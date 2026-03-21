{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hyprpaper
    ./settings.nix
  ];

  options.my.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.my.desktop.hyprland.enable {
    my.desktop.noctalia.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      # package = pkgs.unstable.hyprland;
      # portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
      package = null;
      portalPackage = null;

      plugins = with pkgs.hyprlandPlugins; [
        hy3
        hyprsplit
      ];

      systemd.enable = false;
      xwayland = {
        enable = true;
      };
    };

    services.hyprpolkitagent = {
      enable = true;
      package = pkgs.hyprpolkitagent;
    };
  };
}
