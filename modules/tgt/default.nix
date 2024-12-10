{ config, pkgs, lib, ... }:

let pkg = pkgs.tgt;
    conf = pkgs.writeText "targets.conf" ''
    <target iqn.2020-08.liduur:games>
        backing-store /dev/zvol/storage/games_ntfs
        initiator-address 192.168.144.11
    </target>
    '';
in {
  environment.systemPackages = [ pkg ];

  systemd.services.tgt = {
    after = [ "network.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "(i)SCSI target daemon";

    reloadTriggers = [ conf ];

    serviceConfig = {
      Type = "notify";
      TasksMax = "infinity";
      ExecStart = "${pkg}/bin/tgtd -D";
      ExecStartPost = [
        "${pkg}/bin/tgtadm --op update --mode sys --name State -v offline"
        "${pkg}/bin/tgt-admin -e -c /etc/tgt/targets.conf"
        "${pkg}/bin/tgtadm --op update --mode sys --name State -v ready"
      ];

      ExecStop = [
        "${pkg}/bin/tgtadm --op update --mode sys --name State -v offline"
        "${pkg}/bin/tgt-admin --offline ALL"
        "${pkg}/bin/tgt-admin --update ALL -c /dev/null -f"
        "${pkg}/bin/tgtadm --op delete --mode system"
      ];

      ExecReload = "${pkg}/bin/tgt-admin --update ALL -c /etc/tgt/targets.conf";
      Restart = "on-failure";
    };
  };

  environment.etc."tgt/targets.conf".source = conf;
}
