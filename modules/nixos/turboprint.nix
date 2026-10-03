{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.turboprint;
  cups = config.services.printing.package;
in
{
  options.my.turboprint = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "turboprint" { };
    cupsDriverPackage = mkPackageOption pkgs "turboprint-cups-driver" { };

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

    services.printing = {
      enable = mkDefault true;
      drivers = [ cfg.cupsDriverPackage ];
    };

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
      TPPATH_TEMP=/run/turboprint
      TPPATH_MAN=$out/share/man
      TPPATH_CUPSDRIVER=${cups}/share/cups/model
      TPPATH_CUPSSETTINGS=/etc/cups/ppd
      TPPATH_CUPSLIB=${cups}/lib/cups
      TPPATH_CUPSLIB64=${cups}/lib/cups
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

    systemd.tmpfiles.rules =
      let
        normalUsers = lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
      in
      # filters run as 'cups', the daemon as '${cfg.daemon.user}' and the GUI as the
      # logged-in user, so the shared trees must be writable by all of them
      (lib.concatMap (u: [
        # per-user spool directories that upstream would create via tpsetup --update
        "d /var/spool/turboprint/${u} 1777 - -"
        "d /var/spool/turboprint/${u}/prv 1777 - -"
      ]) normalUsers)
      ++ [
        # temp/job spool area used by the CUPS filters ($TPPATH_TEMP/turboprint)
        "d /run/turboprint 1777 - -"
        "d /var/lib/turboprint 0770 ${cfg.daemon.user} users -"
        "d /var/log/turboprint 1777 ${cfg.daemon.user} users -"
        "d /var/spool/turboprint 1777 ${cfg.daemon.user} users -"
      ];

    systemd.services.turboprint-daemon = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Turboprint Monitor Daemon";
      after = [ "cups.service" ];
      path = [ pkgs.procps ];

      serviceConfig = {
        # tprintdaemon double-forks, writes no pidfile and has no foreground
        # mode; the daemon stays in this unit's cgroup, so stop still works
        Type = "oneshot";
        RemainAfterExit = true;

        EnvironmentFile = [ "/etc/turboprint/system.cfg" ];

        # the upstream unit runs an init script that su's to the tp user;
        # the binary itself never drops privileges, so run it directly as it
        User = cfg.daemon.user;
        Group = cfg.daemon.group;
        UMask = "0000";

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

    # TODO: needs python3 with gi + Gtk3/AyatanaAppIndicator3/Notify typelibs,
    # plus a copy of tpapplet.py with the hardcoded /usr paths patched
    systemd.user.services.turboprint-applet = {
      enable = false;
      description = "TurboPrint Tray Applet";

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
