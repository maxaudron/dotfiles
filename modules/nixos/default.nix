{ lib, ... }:
with lib;
rec {
  common = import ./common.nix;
  udev = import ./udev.nix;

  audio = import ./audio;
  autologin = import ./autologin;
  klipper = import ./klipper;
  tgt = import ./tgt;
  yubikey = import ./yubikey;
  uwsm = import ./uwsm.nix;

  # vfio = import ./vfio;

  default =
    { ... }:
    {
      imports = [
        common
        udev

        autologin
        yubikey
        audio
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
