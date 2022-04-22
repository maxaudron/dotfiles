{ config, lib, pkgs, ... }:

let grub2-theme = pkgs.callPackage ../../pkgs/grub2-theme {};
in {
  imports = [ ];

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox-wayland

    xfce.thunar

    qt5.qtwayland
  ];

  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.audron = {
    isNormalUser = true;
    password = "audron";
    extraGroups = [ "wheel" "libvirtd" "audio" ];
    shell = pkgs.zsh;
  };

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

  services.xserver.enable = false;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
