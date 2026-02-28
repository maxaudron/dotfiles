# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./wireplumber.nix
    ./hardware-configuration.nix

    ../../modules/audio
    ../../modules/common
    ../../modules/yubikey
    ../../modules/home-manager
    ../../modules/tgt
    ../../modules/klipper
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
  ];

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.autoconf" = "0";
    "net.ipv6.conf.enp5s0.accept_ra" = "0";
    "vm.swappiness" = 10;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.openssh = {
    enable = true;
  };

  virtualisation.podman = {
    enable = true;
    enableNvidia = false;
    dockerSocket.enable = true;
    extraPackages = with pkgs; [ su ];
  };

  environment.systemPackages = [ pkgs.simple-scan ];
  hardware.sane = {
    enable = true;
    extraBackends = [ ];
  };

  hardware.graphics = {
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
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
    interfaces.enp5s0.ipv4.addresses = [
      {
        address = "192.168.144.10";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.144.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hosts = {
      "192.168.144.5" = [ "home.fritz.box" ];
      "49.12.98.100" = [ "mail.cocaine.farm" ];
    };

    firewall.enable = false;

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          privateKeyFile = "/etc/wireguard/privatekey";
          ips = [
            "10.10.0.10/24"
            "2a0f:9400:8020:beef::10/128"
            "fd15:3d8c:d429:beef::10/128"
          ];
          peers = [
            {
              endpoint = "ettves.vapor.systems:51820";
              publicKey = "5OTaf4MnSzTcCR10CGSrLFngGa3gdzajbqUKkRF+WlY=";
              allowedIPs = [
                # Wireguard peers
                "10.10.0.0/24"
                "2a0f:9400:8020:beef::/64"
                "fd15:3d8c:d429:beef::/64"
              ];
            }
            {
              endpoint = "phaenn.vapor.systems:51820";
              publicKey = "GmUvA3L8M2+N59my6MeoGwDD8puLOO5/Rbe29WtduBI=";
              allowedIPs = [
                # Wireguard peers
                "10.10.0.2/32"
                "2a0f:9400:8020:beef::2/128"
                "fd15:3d8c:d429:beef::2/128"
              ];
            }
          ];
        };
      };
    };
  };

  services.samba = {
    enable = true;
    settings = {
      global = {
        "server string" = "liduur";
        "netbios name" = "liduur";
        "security" = "user";
        "hosts allow" = "192.168.144.0/24 10.1.0.0/24 127.0.0.1 localhost";
        "guest account" = "nobody";
        "map to guest" = "bad user";

        "client min protocol" = "SMB2";
        "client max protocol" = "SMB3";
      };
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
        "vfs objects" = "streams_xattr";
      };
      media = {
        path = "/mnt/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
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

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    user = "audron";
    group = "users";

    settings = {
      devices = {
        "ettves" = {
          id = "F7QPQBF-65ZOQCZ-3RWJE55-7H6TZOH-W6EEWGW-STJH5EZ-5QG5YGR-P6FHWQC";
        };
        "ffm0089" = {
          id = "D5LYWQQ-GRV6QOK-RXYD32P-YNNFU3C-C7XOEY2-EWHCWSQ-3XC4CHG-EWMOMQZ";
        };
      };
      folders = {
        ".org" = {
          path = "/home/audron/.org";
          devices = [
            "ffm0089"
            "ettves"
          ];
        };
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  programs.uwsm = {
    enable = true;

    # waylandCompositors = {
    #   hyprland = {
    #     prettyName = "Hyprland";
    #     comment = "Hyprland compositor managed by UWSM";
    #     binPath = "${config.programs.hyprland.package}/bin/Hyprland";
    #   };
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
