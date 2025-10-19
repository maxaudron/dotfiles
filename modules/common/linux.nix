{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:

{
  imports = [ 
    ./udev.nix
    "${nixpkgs-unstable}/nixos/modules/services/display-managers/lemurs.nix"
  ];

  security.sudo.wheelNeedsPassword = false;

  boot.loader = {
    grub = {
      configurationLimit = 3;

      gfxmodeEfi = "3840x2160x32,auto";
      gfxmodeBios = "3840x2160x32,auto";
      gfxpayloadEfi = "keep";
      gfxpayloadBios = "keep";
    };

    timeout = 1;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dfu-util
    usbutils
  ];

  services.printing = {
    enable = true;
    drivers = [ ];
  };

  services.nfs.server.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  programs.dconf.enable = true;
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.audron = {
    isNormalUser = true;
    password = "audron";
    extraGroups = [
      "wheel"
      "input"
      "libvirtd"
      "audio"
      "wireshark"
      "dialout"
      "video"
      "adbusers"
      "scanner"
      "seat"
      "lp"
    ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2eIUtbt7RM75ThjKfUjm24QkzkzCSj7hs+GLaaxMeH"
    ];
  };

  programs.zsh = {
    enable = true;
  };

  programs.fish.enable = true;

  programs.wireshark = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "IBM Plex Serif" ];
      sansSerif = [ "IBM Plex Sans" ];
      monospace = [ "Spleen" ];

      emoji = [ "Noto Color Emoji" ];
    };

    allowBitmaps = true;

    localConf = ''
      <match target="pattern">
          <test qual="any" name="family">
            <string>Spleen</string>
          </test>
          <edit name="antialias" mode="assign">
            <bool>false</bool>
          </edit>
          <edit name="hintstyle" mode="assign">
            <const>hintnone</const>
          </edit>
      </match>
    '';
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "all" ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
      LC_CTYPE = "en_GB.UTF-8";
      LC_ALL = "en_GB.UTF-8";
    };
  };
  console = {
    font = "${pkgs.spleen}/share/consolefonts/spleen-16x32.psfu";
    packages = [ pkgs.spleen ];
    keyMap = "us";
  };

  networking.nftables.enable = true;

  services = {
    xserver = {
      enable = true;
      wacom.enable = true;
      displayManager.lightdm.enable = false;
    };

    displayManager = {
      lemurs = {
        enable = true;
        settings = {};
      };
      sessionPackages = [ ];
    };
  };

  systemd.services.display-manager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
