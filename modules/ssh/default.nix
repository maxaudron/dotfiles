{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      StrictHostKeyChecking=no
    '';

    matchBlocks = {
      "*" = {
        userKnownHostsFile = "/dev/null";

        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
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
    };
  };
}
