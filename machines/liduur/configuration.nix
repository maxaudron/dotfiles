# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/audio
    ../../modules/common
    ../../modules/yubikey
    ../../modules/home-manager
    ../../modules/vfio
  ];

  vfio.devices = [ "0000:09:00.0" "0000:09:00.1" "0000:0e:00.3" ];

  audio.defaultLinks = [
    {
      input =
        "alsa_input.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-input-0:capture_AUX8";
      output =
        "alsa_output.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-output-0:playback_AUX0";
    }
    {
      input =
        "alsa_input.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-input-0:capture_AUX9";
      output =
        "alsa_output.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-output-0:playback_AUX1";
    }
  ];

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.autoconf" = "0";
    "net.ipv6.conf.enp5s0.accept_ra" = "0";
  };

  networking = {
    hostName = "liduur";
    domain = "vapor.systems";
    hostId = "faedb34d";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = true;
    enableIPv6 = true;
    interfaces.enp5s0.tempAddress = "disabled";
    interfaces.br0.tempAddress = "disabled";
    interfaces.br0.ipv4.addresses = [{
      address = "192.168.144.10";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.144.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    bridges = { "br0" = { interfaces = [ "enp5s0" ]; }; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
