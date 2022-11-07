{ config, pkgs, lib, ... }:

let conf = import ../config { inherit lib; };
in {
  config = lib.mkMerge [
    {
      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    }

    (lib.mkIf (conf.os.type == "linux") {
      programs = {
        ssh.startAgent = false;
        gnupg.agent = { pinentryFlavor = "qt"; };
      };

      services.pcscd.enable = true;
    })
  ];
}
