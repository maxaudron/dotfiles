# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/audio
    ../../modules/common
    ../../modules/yubikey
    ../../modules/home-manager
    ../../modules/xp-pen
  ];

  audio.autoConnect = [
    {
      input = "System Output:*";
      output = "FiiO USB DAC-E10:*";
      connect = {
        "AUX2" = "FL";
        "AUX3" = "FR";
      };
    }
    {
      input = "UMC1820:capture_*";
      output = "System Output:*";
      connect = {
        "AUX8" = "FL";
        "AUX9" = "FR";
      };
    }
    {
      input = "UMC1820:capture_*";
      output = "Microphone:*";
      connect = {
        "AUX0" = "AUX0";
        "AUX1" = "AUX1";
      };
    }
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.autoconf" = "0";
    "net.ipv6.conf.enp5s0.accept_ra" = "0";
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.openssh = { enable = true; };

  virtualisation.podman = {
    enable = true;
    enableNvidia = true;
    dockerSocket.enable = true;
    extraPackages = with pkgs; [ su ];
  };

  environment.systemPackages = [ pkgs.simple-scan ];
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  networking = {
    hostName = "liduur";
    domain = "vapor.systems";
    hostId = "faedb34d";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = true;
    enableIPv6 = true;

    # 10G Interface
    interfaces.enp5s0.tempAddress = "disabled";
    interfaces.enp5s0.ipv4.addresses = [{
      address = "192.168.144.10";
      prefixLength = 24;
    }];

    defaultGateway = "192.168.144.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    hosts = {
      "192.168.144.5" = [ "home.fritz.box" ];
      "49.12.98.100" = [ "mail.cocaine.farm" ];
    };

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

            # "0.0.0.0/1"

            # Kubernetes cluster internal networks
            "10.102.0.0/16"
            "10.101.0.0/16"
            # "fd15:3d8c:d429:101::/64"
            # "fd15:3d8c:d429:102::/64"
          ];
        }];
      };
    };
  };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      server string = liduur
      netbios name = liduur
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.144.0/24 10.1.0.0/24 127.0.0.1 localhost
      # hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user

      client min protocol = SMB2
      client max protocol = SMB3
    '';
    shares = {
      home = {
        path = "/home/audron/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      share = {
        path = "/share";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      games = {
        path = "/mnt/games";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "vfs objects" = "acl_xattr";
        "map acl inherit" = "yes";
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
