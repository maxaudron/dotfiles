{
  config,
  pkgs,
  lib,
  ...
}:

let
  conf = import ../config { inherit lib; };
in
{
  config = lib.mkMerge [
    {
      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.wayprompt;
        };
      };
    }

    (lib.mkIf (conf.os.type == "linux") {
      programs = {
        ssh.startAgent = false;
        gnupg.agent = {
        };
      };

      hardware.gpgSmartcards.enable = true;
      services.pcscd.enable = true;
      services.udev.packages = [ pkgs.yubikey-personalization ];

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.debian.pcsc-lite.access_card") {
            return polkit.Result.YES;
          }
        });

        polkit.addRule(function(action, subject) {
          if (action.id == "org.debian.pcsc-lite.access_pcsc") {
            return polkit.Result.YES;
          }
        });
      '';
    })
  ];
}
