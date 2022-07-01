{ config, pkgs, lib, nixpkgs, nixpkgs-unstable, darwin, home-manager, fenix
, emacs, ... }:

let conf = import ../config { inherit lib; };

in {
  imports = (if conf.os.type == "linux" then
    [ ./linux.nix ]
  else if conf.os.type == "darwin" then
    [ ./darwin.nix ]
  else
    [ ]);

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
    rclone

    nixfmt

    pass
    passExtensions.pass-update
    passff-host
  ];

  nix.trustedUsers = [ "@wheel" ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.fonts = with pkgs; [ ibm-plex nerdfonts ];

  # Enable zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  nixpkgs.overlays = [ (import ../../pkgs) ];

  environment.etc = {
    "nix/channels/nixpkgs".source = nixpkgs.outPath;
    "nix/channels/nixpkgs-unstable".source = nixpkgs-unstable.outPath;
    "nix/channels/home-manager".source = home-manager.outPath;
  };

  # Setup caches
  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
      secret-key-files = /etc/nix/cache-priv-key.pem
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nix.web.deuxfleurs.fr"
      "https://nix.cache.vapor.systems"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nix.web.deuxfleurs.fr:eTGL6kvaQn6cDR/F9lDYUIP9nCVR/kkshYfLDJf1yKs="
      "nix.cache.vapor.systems-1:OjV+eZuOK+im1n8tuwHdT+9hkQVoJORdX96FvWcMABk="
    ];

    registry = {
      nixpkgs.flake = nixpkgs;
      nixpkgs-unstable.flake = nixpkgs-unstable;
      home-manager.flake = home-manager;
      darwin.flake = darwin;
      fenix.flake = fenix;
      emacs.flake = emacs;
    };

    nixPath = [
      "nixpkgs=/etc/nix/channels/nixpkgs"
      "nixpkgs-unstable=/etc/nix/channels/nixpkgs-unstable"
      "home-manager=/etc/nix/channels/home-manager"
    ];
  };
}
