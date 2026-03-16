{ pkgs, ... }:

{
  imports = [
    ./hyprpaper
    ./quickshell
    # ./mako

    ./settings.nix

    ../common/userland.nix
  ];

  home.packages = [
    pkgs.unstable.quickshell
  ];

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
}
