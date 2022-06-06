{ config, pkgs, lib, ... }:

let conf = import ../config { inherit lib; };

in {
  imports = (if conf.os.type == "linux" then [ ./linux.nix ] else [ ]);

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

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay";
      ref = "master";
      rev = "4a128aff2349006582335b835831519bf4413ed0";
    }))

    (import (builtins.fetchGit {
      url = "https://github.com/oxalica/rust-overlay";
      ref = "master";
      rev = "77c13b096bdd5f39b9017f75d3b98dcc64b893e8";
    }))
  ];

  # Setup caches
  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nix.web.deuxfleurs.fr"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix.web.deuxfleurs.fr:eTGL6kvaQn6cDR/F9lDYUIP9nCVR/kkshYfLDJf1yKs="
    ];
  };
}
