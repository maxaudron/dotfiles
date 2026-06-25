{ lib, ... }:
with lib;
rec {
  common = import ./common.nix;
  secrets = import ./secrets.nix;
  udev = import ./udev.nix;

  acme = import ./acme.nix;
  audio = import ./audio;
  autologin = import ./autologin;
  klipper = import ./klipper;
  tgt = import ./tgt;
  yubikey = import ./yubikey;
  uwsm = import ./uwsm.nix;
  kmscon = import ./kmscon.nix;

  # vfio = import ./vfio;

  default =
    { ... }:
    {
      imports = [
        common
        secrets
        udev

        acme
        audio
        autologin
        yubikey
        kmscon
        uwsm
        tgt
      ];

      config = {
        my.audio = {
          enable = mkDefault true;
          filter.output = mkDefault true;
        };
      };
    };
}
