{
  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nix.cache.vapor.systems"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix.cache.vapor.systems-1:OjV+eZuOK+im1n8tuwHdT+9hkQVoJORdX96FvWcMABk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, fenix, crane }:
    with nixpkgs.lib;
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        rustToolchain = fenix.packages.${system}.stable.toolchain;

        # crane setup
        craneLib = crane.lib.${system}.overrideToolchain rustToolchain;
        src = craneLib.cleanCargoSource ./.;

        cargoArtifacts = craneLib.buildDepsOnly {
          inherit src;

          nativeBuildInputs = with pkgs; [ rustToolchain pkg-config ];
        };
      in {
        packages.default =
          craneLib.buildPackage { inherit cargoArtifacts src; };

        devShells.default = pkgs.mkShell {
          # Extra inputs can be added here
          nativeBuildInputs = with pkgs; [ rustToolchain pkg-config ];
        };
      });
}
