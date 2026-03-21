{ config, lib, ... }:

let
  cfg = config.home-manager.users."${config.my.user.name}";
in
{
  programs.uwsm = {
    enable = true;

    waylandCompositors = {
      hyprland = lib.mkIf cfg.my.desktop.hyprland.enable {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "${cfg.wayland.windowManager.hyprland.package}/bin/Hyprland";
      };
      
      sway = lib.mkIf cfg.my.desktop.sway.enable {
        prettyName = "sway";
        comment = "sway compositor managed by UWSM";
        binPath = "${cfg.wayland.windowManager.sway.package}/bin/sway";
      };
    };
  };
}
