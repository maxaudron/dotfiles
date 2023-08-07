{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    secrets = {
      url = "git+ssh://git@gitlab.com/audron/secrets.git";
      flake = false;
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs.url = "github:nix-community/emacs-overlay";

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    gtree = {
      url = "gitlab:cocainefarm/gtree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixpkgs-master, secrets, darwin, home-manager
    , hyprland, fenix, emacs, gtree, doomemacs }:
    let
      specialArgs = inputs // { inherit inputs; };

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };
      overlay-master = final: prev: {
        master = import nixpkgs-master {
          system = prev.system;
          config.allowUnfree = true;
        };
      };
      overlays = { config, pkgs, ... }: {
        nixpkgs.overlays = [ overlay-unstable overlay-master ];
      };
    in {
      nixosConfigurations.liduur = let system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = specialArgs // { inherit system; };
        modules = [
          overlays

          home-manager.nixosModules.home-manager

          ./machines/liduur/configuration.nix
        ];
      };
      darwinConfigurations.ffma0089 = let system = "aarch64-darwin";
      in darwin.lib.darwinSystem {
        inherit system;
        specialArgs = specialArgs // { inherit system; };
        modules = [
          overlays

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = specialArgs // {
                inherit builtins;
                inherit system;
              };
            };
          }
          ./machines/ffma0089/configuration.nix
        ];
      };
    };
}
