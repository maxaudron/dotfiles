{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    zip
    unzip
    wget
    htop
    nixfmt
    firefox-wayland

    xfce.thunar

    greetd.tuigreet

    qt5.qtwayland
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  nix.trustedUsers = [ "@wheel" ];
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.audron = {
    isNormalUser = true;
    password = "audron";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  # services.xserver.displayManager.startx.enable = true;

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

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [ ibm-plex nerdfonts ];

  # Enable zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Pull in emacs with pgkt and native comp
  services.emacs.package = pkgs.emacsPgtkGcc;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay";
      ref = "master";
      rev = "4a128aff2349006582335b835831519bf4413ed0";
    }))

    (self: super: {
      teamspeak5 = super.callPackage ../../pkgs/teamspeak5 { };
    })
  ];
}
