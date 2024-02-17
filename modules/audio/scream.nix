{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    pipewire-scream = {
      wantedBy = [ "pipewire.service" ];
      requires = [ "pipewire.service" ];
      after = [ "pipewire.service" ];
      description = "Start the scream server to receive audio from windows";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scream}/bin/scream -o pulse -s windows -i enp5s0";
      };
    };
  };
}
