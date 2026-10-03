{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.turboprint;
in
{
  options.my.turboprint = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "turboprint" { };
    cupsPackage = mkPackageOption pkgs "cups" { };

    daemon = {
      user = mkOption {
        type = types.str;
        default = "turboprint";
      };
      group = mkOption {
        type = types.str;
        default = "turboprint";
      };
    };
    browser = mkOption {
      type = types.str;
      default = "firefox";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."turboprint/system.cfg".text = ''
      TPBIN_BROWSER=${pkgs.xdg-utils}/bin/xdg-open
      TPFILE_PRINTCAP=/etc/printcap
      TPPATH_CONFIG=/var/lib/turboprint
      TPPATH_SHARE=${cfg.package}/share/turboprint
      TPPATH_SPOOL=/var/spool/lpd
      TPPATH_BIN=${cfg.package}/bin
      TPPATH_FILTERS=${cfg.package}/lib/turboprint
      TPPATH_DOC=${cfg.package}/share/doc/turboprint
      TPPATH_LOG=/var/log
      TPPATH_VAR=/var/spool
      TPPATH_TEMP=/tmp
      TPPATH_MAN=$out/share/man
      TPPATH_CUPSDRIVER=${cfg.cupsPackage}/share/cups/model
      TPPATH_CUPSSETTINGS=/etc/cups/ppd
      TPPATH_CUPSLIB=${cfg.cupsPackage}/lib/cups
      TPPATH_CUPSLIB64=${cfg.cupsPackage}/lib/cups
      TPOWN_SPOOLDIR=${cfg.daemon.user}
      TPMOD_SPOOLDIR=0755
      TPOWN_SPOOLFILE=${cfg.daemon.user}
      TPMOD_SPOOLFILE=0640
      TPDAEMON_START=1
      TPDAEMON_USER=${cfg.daemon.user}
      TPDAEMON_GROUP=${cfg.daemon.group}
      TPDAEMON_PORT=5552
      TPDAEMON_SERVER=1
      TPUSE_GSZEDO=1
      TPCONVERT_PDF=0
    '';

    users.users.${cfg.daemon.user} = {
      isSystemUser = true;
      group = cfg.daemon.group;
      extraGroups = [
        "lp"
        "lpadmin"
      ];
    };

    users.groups.${cfg.daemon.group} = { };

    systemd.tmpfiles.rules = [
      "d /var/lib/turboprint 0770 ${cfg.daemon.user} users -"
    ];

    systemd.services.turboprint-daemon = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Turboprint Monitor Daemon";
      after = [ "cups.service" ];
      path = [ pkgs.procps ];

      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
        RemainAfterExit = "no";

        EnvironmentFiles = [ "/etc/turboprint/system.cfg" ];

        User = cfg.daemon.user;
        Group = cfg.daemon.group;

        ExecStart = "${cfg.package}/bin/tprintdaemon 0";
      };
    };

    systemd.user.services.turboprint-userdaemon = {
      enable = true;
      description = "Turboprint User Daemon";

      wantedBy = [ "default.target" ];
      after = [ "turboprint-monitor.service" ];

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = [ "/etc/turboprint/system.cfg" ];
        ExecStart = "${cfg.package}/bin/turboprint-userdaemon";
      };
    };

    systemd.user.services.turboprint-monitor = {
      enable = true;
      description = "Turboprint Monitor";

      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = [ "/etc/turboprint/system.cfg" ];
        ExecStart = "${cfg.package}/bin/turboprint-monitor 0 -hide";
      };
    };

    systemd.user.services.turboprint-applet = {
      enable = true;
      description = "Turboprint Tray Applet";

      wantedBy = [ "default.target" ];
      after = [ "turboprint-monitor.service" ];

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = [ "/etc/turboprint/system.cfg" ];
        ExecStart = "${pkgs.python3}/bin/python3 ${cfg.package}/lib/turboprint/appindicator3/tpapplet.py";
      };
    };
  };
}
