{
  config,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.mosh ];
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "Host *" = {
        UserKnownHostsFile = "/dev/null";
        StrictHostKeyChecking = "no";

        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";

        SetEnv = {
          TERM = "xterm-256color";
        };
      };

      "Host *.vapor.systems" =
        let
          localDir =
            if pkgs.stdenv.isDarwin then
              "${config.home.homeDirectory}/.gnupg"
            else
              "/run/user/1000/gnupg/S.gpg-agent.extra";
          remoteDir = "/run/user/1000/gnupg";
        in
        {
          User = "audron";
          ForwardAgent = true;
          RemoteForward = [
            "${remoteDir}/S.gpg-agent ${localDir}/S.gpg-agent.extra"
            "${remoteDir}/S.gpg-agent.ssh ${localDir}/S.gpg-agent.ssh"
          ];
          SetEnv = {
            SSH_AUTH_SOCK = "${remoteDir}/S.gpg-agent.ssh";
          };
        };

      "Host 10.53.10.* 10.53.11.* 10.53.0.* 10.51.0.* 10.52.0.*" = {
        proxyJump = "mgt01.rancher.shared-k8s.de.clara.net";
      };

      "Host 10.55.0.* 10.55.12.* 10.55.10.*" = {
        proxyJump = "rancher.cke.validatis.mgt.de.clara.net";
      };

      "Host 10.55.15.* 10.55.16.*" = {
        proxyJump = "rancher.cke.hosenso.mgt.de.clara.net";
      };
    };
  };

  services.ssh-agent.enable = !config.my.core.gpg.enable;
}
