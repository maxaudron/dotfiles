{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../common
  ];

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [ ];

  services.printing = {
    enable = true;
    drivers = [ ];
  };

  services.nfs.server.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.autologin.enableGnomeKeyring = true;
  services.seatd.enable = true;

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups = {
      media = {
        gid = 989;
      };
    };
    users.audron = {
      isNormalUser = true;
      password = "audron";
      extraGroups = [
        "acme"
        "wheel"
        "input"
        "libvirtd"
        "audio"
        "media"
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
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "peach";
    flavor = "mocha";

    cache.enable = true;
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
      serif = [
        "IBM Plex Serif"
        "Symbols Nerd Font"
      ];
      sansSerif = [
        "IBM Plex Sans"
        "Symbols Nerd Font"
      ];
      monospace = [
        "TX-02"
        "Symbols Nerd Font Mono"
      ];

      emoji = [ "Twitter Color Emoji" ];
    };

    antialias = true;

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };

    hinting = {
      enable = true;
      style = "slight";
      autohint = false;
    };
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

  services.xserver.xkb = {
    layout = "us";
    options = "compose:rctrl";
  };

  networking.nftables.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = false;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
