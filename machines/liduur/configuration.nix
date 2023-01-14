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

  vfio.devices = [ "0000:0c:00.1" "0000:0e:00.3" ];
  vfio.gpu = [ "0000:0c:00.0" ];

  audio.defaultLinks = [
    {
      input =
        "alsa_input.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-input-0:capture_AUX8";
      output = "System Output:playback_FL";
    }
    {
      input =
        "alsa_input.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-input-0:capture_AUX9";
      output = "System Output:playback_FR";
    }
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.autoconf" = "0";
    "net.ipv6.conf.enp5s0.accept_ra" = "0";
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.openssh = { enable = true; };

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

    hosts = { "192.168.144.74" = [ "home.fritz.box" ]; };

    firewall.enable = false;

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        privateKeyFile = "/etc/wireguard/privatekey";
        ips = [
          "10.10.0.10/24"
          "2a0f:9400:8020:beef::10/128"
          "fd15:3d8c:d429:beef::10/128"
        ];
        peers = [{
          endpoint = "ettves.vapor.systems:51820";
          publicKey = "5OTaf4MnSzTcCR10CGSrLFngGa3gdzajbqUKkRF+WlY=";
          allowedIPs = [
            # Wireguard peers
            "10.10.0.0/24"
            "2a0f:9400:8020:beef::/64"
            "fd15:3d8c:d429:beef::/64"

            # Kubernetes cluster internal networks
            "10.102.0.0/16"
            "10.101.0.0/16"
            "fd15:3d8c:d429:101::/64"
            "fd15:3d8c:d429:102::/64"
          ];
        }];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
