{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "/dev/null";
    extraConfig = ''
      StrictHostKeyChecking=no
    '';
  };
}
