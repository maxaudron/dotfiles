{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.displayManager.autologin;
in
{
  options.services.displayManager.autologin = {
    enable = mkEnableOption "" // {
      description = ''
        Whether to enable autologin, a service to log in automatically

        ::: {.note}
        For Wayland compositors, your user must be in the "seat" group.
        :::
      '';
    };

    package = mkPackageOption pkgs "autologin" { };

    user = mkOption {
      type = types.str;
      description = ''
        username of the user to log in as.
      '';
    };

    command = mkOption {
      type = types.str;
      description = ''
        command passed to autologin to start the session
      '';
      default = "${pkgs.uwsm}/bin/uwsm start default";
    };
  };

  config = mkIf cfg.enable {
    systemd.services."autovt@tty1".enable = false;

    services = {
      dbus.packages = [ cfg.package ];
      displayManager = {
        enable = true;
        execCmd = "${cfg.package}/bin/autologin ${cfg.user} ${cfg.command}";
      };
      seatd.enable = true;
      xserver = {
        display = null;
      };
    };

    systemd.services.display-manager = {
      enable = true;
      unitConfig = {
        Wants = [ "systemd-user-sessions.service" ];
        After = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
        ];
      };

      serviceConfig = {
        Type = "simple";

        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
        TimeoutStopSec = "30s";
        KeyringMode = "shared";
      };

      restartIfChanged = false;
    };

    security.pam.services.autologin = {
      enable = true;
      name = "autologin";
      startSession = true;
      setLoginUid = true;
      updateWtmp = true;
    };
  };
}
