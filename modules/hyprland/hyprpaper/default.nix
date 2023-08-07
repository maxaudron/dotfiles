{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    hyprpaper = {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
        Description = "Hyprland Wallpaper Manager";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  xdg.configFile."hypr/hyprpaper.conf" = {
    source = ./hyprpaper.conf;
    onChange = ''
      ${pkgs.systemd}/bin/systemctl --user restart hyprpaper || true
    '';
  };
}
