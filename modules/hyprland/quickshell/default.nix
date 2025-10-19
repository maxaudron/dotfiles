{
  pkgs,
  lib,
  system,
  noctalia,
  ...
}:

let
  package = noctalia.packages."${system}".default.override {
    quickshell = pkgs.unstable.quickshell;
  };
  target = "graphical-session.target";
in
{
  imports = [ noctalia.homeModules.default ];

  # services.noctalia-shell.enable = true;
  programs.noctalia-shell = {
    enable = true;
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
      colorSchemes.predefinedScheme = "Catppuccin";
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

  systemd.user.services.noctalia-shell = {
    Unit = {
      description = "Noctalia Shell - Wayland desktop shell";
      documentation = [ "https://github.com/noctalia-dev/noctalia-shell" ];
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
      After = [ target ];
      PartOf = [ target ];
    };

    Install = {
      WantedBy = [ target ];
    };

    Service = {
      ExecStart = "${package}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 3;
      RestartTriggers = [ package ];
      TimeoutStartSec = 10;
      TimeoutStopSec = 5;
      Environment = [
        "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
      ];
    };
  };

  home.packages = [ package ];
}
