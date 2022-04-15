{ config, pkgs, lib, ... }:

let conf = lib.importTOML ../../config.toml;
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
    })
  ];
}
