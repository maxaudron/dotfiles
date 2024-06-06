{ config, lib, pkgs, ... }:

{
  systemd.user.services = {
    pipewire-scream = {
      wantedBy = [ "default.target" ];
      requires = [ "pipewire.service" "pipewire-pulse.socket" ];
      after = [ "pipewire.service" ];
      description = "Start the scream server to receive audio from windows";
      preStart = "${pkgs.bash} -c 'sleep 10'";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scream}/bin/scream -o pulse -s windows -i enp5s0";
      };
    };
  };
}
