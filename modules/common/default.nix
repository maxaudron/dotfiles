{
  config,
  pkgs,
  lib,
  nixpkgs,
  nixpkgs-unstable,
  darwin,
  home-manager,
  fenix,
  secrets,
  ...
}:

let
  conf = import ../config { inherit lib; };

in
{
  imports = (
    if conf.os.type == "linux" then
      [ ./linux.nix ]
    # else if conf.os.type == "darwin" then
    #   [ ./darwin.nix ]
    else
      [ ]
  );

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

    mtr
    ipcalc

    nixfmt-rfc-style

    pass
    passExtensions.pass-update

    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];

  # Enable zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    spleen
    (callPackage "${secrets}/fonts/default.nix" {})
  ];

  nixpkgs.overlays = [ (import ../../pkgs) ];

  environment.etc = {
    "nix/channels/nixpkgs".source = nixpkgs.outPath;
    "nix/channels/nixpkgs-unstable".source = nixpkgs-unstable.outPath;
    "nix/channels/home-manager".source = home-manager.outPath;
  };

  # Setup caches
  nix = {
    enable = true;

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
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
