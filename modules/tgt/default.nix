{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.tgt ];

  systemd.units.tgt = {
    after = [ "network.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "iSCSI Server";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.tgt}/bin/tgtd -D";
    };
  };
}
