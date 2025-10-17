{
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    secrets = {
      url = "git+ssh://git@gitlab.com/audron/secrets.git";
      flake = false;
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gtree = {
      url = "gitlab:cocainefarm/gtree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      determinate,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      secrets,
      darwin,
      home-manager,
      fenix,
      gtree,
    }:
    let
      specialArgs = inputs // {
        inherit inputs;
      };

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
      overlays =
        { config, pkgs, ... }:
        {
          nixpkgs.overlays = [
            overlay-unstable
            overlay-master
          ];
        };
    in
    {
      nixosConfigurations.liduur =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit system;
          };
          modules = [
            overlays
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            ./machines/liduur/configuration.nix
          ];
        };
      darwinConfigurations.ffma0089 =
        let
          system = "aarch64-darwin";
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit system;
          };
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
