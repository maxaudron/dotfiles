{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "/dev/null";
    extraConfig = ''
      StrictHostKeyChecking=no
    '';

    matchBlocks = {
      "10.49.212.* 10.49.213.* 10.49.214.*" = {
        proxyJump = "rancher.cke.de.clara.net";
      };

      "10.53.10.* 10.53.11.* 10.53.0.* 10.51.0.* 10.52.0.*" = {
        proxyJump = "mgt01.rancher.shared-k8s.de.clara.net";
      };

      "10.55.0.* 10.55.12.* 10.55.10.*" = {
        proxyJump = "rancher.cke.validatis.mgt.de.clara.net";
      };

      "10.55.15.* 10.55.16.*" = {
        proxyJump = "rancher.cke.hosenso.mgt.de.clara.net";
      };

      "10.55.0.12 10.55.11.*" = {
        proxyJump = "rancher.cke.baumann.mgt.de.clara.net";
      };
    };
  };
}
