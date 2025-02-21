{ config, pkgs, lib, nixpkgs, nixpkgs-unstable, darwin, home-manager, fenix
, emacs, ... }:

let conf = import ../config { inherit lib; };

in {
  imports = (if conf.os.type == "linux" then
    [ ./linux.nix ]
  # else if conf.os.type == "darwin" then
  #   [ ./darwin.nix ]
  else
    [ ]);

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    jq
    git
    dig
    vim
    zip
    unzip
    wget
    htop
    watch
    rename
    p7zip
    rclone

    nixfmt-rfc-style

    pass
    passExtensions.pass-update
  ];

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

    optimise.automatic = true;

    distributedBuilds = true;
    settings = {
      builders = "@/etc/nix/machines";
      trusted-users = [ "@wheel" ];

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
