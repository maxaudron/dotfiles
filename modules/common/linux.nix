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

    dfu-util
    usbutils
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.audron = {
    isNormalUser = true;
    password = "audron";
    extraGroups = [ "wheel" "libvirtd" "audio" "wireshark" "dialout" ];
    shell = pkgs.zsh;
  };

  programs.wireshark = {
    enable = true;
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

  services.udev.extraRules = ''
    SUBSYSTEM=="block", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", ACTION=="add", SYMLINK+="rp2040upl%n"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6018", GROUP="users", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", GROUP="users", MODE="0666"

    SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBMPGDB"
    SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBMPUart"
  '';
}
