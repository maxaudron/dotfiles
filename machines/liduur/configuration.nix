# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/audio
      ../../modules/common
      ../../modules/yubikey
      ../../modules/home-manager
      ../../modules/vfio
    ];

  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = lib.mkForce [
      { devices = [ "/dev/nvme0n1" ]; path = "/boot/1"; }
      { devices = [ "/dev/nvme1n1" ]; path = "/boot/2"; }
    ];
  };

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "rpool" ];

  networking = {
    hostName = "liduur";
    domain = "vapor.systems";
    hostId = "faedb34d";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = true;
    enableIPv6 = true;
    interfaces.enp9s0.ipv4.addresses = [{
      address = "192.168.144.10";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.144.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
