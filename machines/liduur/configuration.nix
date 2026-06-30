{ config, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./hardware-configuration.nix
    ./wireguard.nix
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

  environment.systemPackages = [ pkgs.simple-scan pkgs.wootility ];
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

  services.displayManager.autologin = {
    enable = true;
    user = config.users.users.audron.name;
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp5s0";
      networkConfig = {
        # start a DHCP Client for IPv4 Addressing/Routing
        DHCP = "ipv4";
        # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
        IPv6AcceptRA = true;
      };
      # make routing on this interface a dependency for network-online.target
      linkConfig.RequiredForOnline = "routable";
    };
  };

  networking = {
    hostName = "liduur";
    domain = "vapor.systems";
    hostId = "faedb34d";
    usePredictableInterfaceNames = true;
    useNetworkd = true;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hosts = {
      "192.168.144.5" = [ "home.fritz.box" ];
      "49.12.98.100" = [ "mail.cocaine.farm" ];
    };

    firewall.enable = false;
  };

  services.tgt = {
    enable = true;
    settings.target = {
      "iqn.2020-08.liduur:games" = {
        backing-store = "/dev/zvol/storage/games_ntfs";
        initiator-address = "192.168.144.11";
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

  my.acme.enable = true;
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAcxPWinEbmLUdJ2JsaGD0Y1nbFeQzf93/twg2WgnQd root@liduur";
  security.acme.certs."wg" =
    let
      domain = "liduur.wg.vapor.systems";
    in
    {
      inherit domain;
      extraDomainNames = [
        "*.${domain}"
      ];
    };

  hardware.wooting.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
