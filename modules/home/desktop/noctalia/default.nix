{
  config,
  pkgs,
  lib,
  system,
  noctalia,
  ...
}:

let
  package = noctalia.packages."${system}".default;
in
{
  imports = [ noctalia.homeModules.default ];

  options.my.desktop.noctalia = {
    enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkIf config.my.desktop.noctalia.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        # configure noctalia here; defaults will
        # be deep merged with these attributes.
        bar = {
          density = "comfortable";
          position = "top";
          widgets = {
            left = [
              {
                id = "Clock";
                formatHorizontal = "yyyy-MM-dd HH:mm";
                formatVertical = "HH mm";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "MediaMini";
                maxWidth = 450;
              }
            ];
            center = [
              {
                id = "Workspace";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };
        general = {
          # avatarImage = "/home/drfoobar/.face";
          showScreenCorners = true;
          radiusRatio = 0.55;
          screenRadiusRatio = 1;
          animationSpeed = 2;
        };
        location = {
          monthBeforeDay = false;
          name = "Frankfurt, Germany";
          showWeekNumberInCalendar = true;
        };
        wallpaper = {
          enabled = false;
        };
        appLauncher = {
          terminalCommand = "${pkgs.alacritty}/bin/alacritty -e";
        };

        ui = {
          fontDefault = "IBM Plex Sans";
          fontFixed = "IBM Plex Mono";
        };
      };
    };

    home.packages = [ package ];
  };
}
