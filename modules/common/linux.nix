{ config, lib, pkgs, ... }:

let grub2-theme = pkgs.callPackage ../../pkgs/grub2-theme { };
in
{
  imports = [ ./udev.nix ];

  security.sudo.wheelNeedsPassword = false;

  boot.loader = {
    grub = {
      configurationLimit = 3;

      theme = "${grub2-theme}/grub/themes/vimix";
      splashImage = "${grub2-theme}/grub/themes/vimix/background.jpg";
      gfxmodeEfi = "3440x1440x32,auto";
      gfxmodeBios = "3440x1440x32,auto";
      gfxpayloadEfi = "keep";
      gfxpayloadBios = "keep";
      font = "${pkgs.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf";
      extraConfig = ''
        insmod gfxterm
        insmod png
        set icondir=($root)/theme/icons
      '';
    };

    timeout = 1;
  };

  fonts.packages = with pkgs; [ ibm-plex nerdfonts ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox-wayland

    xfce.thunar

    qt5.qtwayland

    dfu-util
    usbutils

    colord
    colord-kde

    libsForQt5.bismuth

    gnome.gnome-color-manager
    sqlite

    openhantek6022

    sddm-theme-chili

    browserpass
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  services.flatpak.enable = true;
  services.nfs.server.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  programs.dconf.enable = true;
  programs.adb.enable = true;

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.browserpass ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.audron = {
    isNormalUser = true;
    password = "audron";
    extraGroups =
      [ "wheel" "input" "libvirtd" "audio" "wireshark" "dialout" "video" "adbusers" "scanner" "lp" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2eIUtbt7RM75ThjKfUjm24QkzkzCSj7hs+GLaaxMeH"
    ];
  };

  programs.zsh = {
    enable = true;
  };

  services.xserver.wacom.enable = true;

  programs.wireshark = { enable = true; };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "IBM Plex Serif" ];
      sansSerif = [ "IBM Plex Sans" ];
      monospace = [ "IBM Plex Mono" ];

      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking.nftables.enable = true;

  services.xserver = {
    enable = true;

    displayManager = {
      sddm = {
        enable = true;
        theme = "chili";
      };
      sessionPackages =
        [ config.home-manager.users.audron.wayland.windowManager.hyprland.package ];
    };
  };

  services.colord.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ rocmPackages.clr.icd rocmPackages.clr ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
