{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hyprpaper
  ];

  options.my.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.my.desktop.hyprland.enable {
    my.desktop.noctalia.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;

      plugins = with pkgs.hyprlandPlugins; [
        hy3
        # hyprsplit FIXME
      ];

      systemd.enable = false;
      xwayland = {
        enable = true;
      };

      extraConfig = ''
        require("config/settings")
      '';
    };

    services.hyprpolkitagent = {
      enable = true;
      package = pkgs.hyprpolkitagent;
    };

    xdg.configFile = {
      "hypr/config" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home/desktop/hyprland/lua";
      };
    };
  };
}
