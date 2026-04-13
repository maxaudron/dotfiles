{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nci.url = "github:yusdacra/nix-cargo-integration";
    nci.inputs.nixpkgs.follows = "nixpkgs";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ parts, nci, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [ nci.flakeModule ];
      perSystem =
        {
          self',
          pkgs,
          config,
          lib,
          ...
        }:
        let
          # shorthand for accessing this crate's outputs
          # you can access crate outputs under `config.nci.outputs.<crate name>` (see documentation)
          crateOutputs = config.nci.outputs."PROJECT";
        in
        {
          nci = {
            projects."PROJECT".path = ./.;
            crates.PROJECT =
              let
                mkDerivation = {
                  # inputs and most other stuff will automatically merge
                  nativeBuildInputs = with pkgs; [ ];
                };
              in
              {
                drvConfig = { inherit mkDerivation; };
                depsDrvConfig = { inherit mkDerivation; };
              };

            toolchainConfig = {
              channel = "stable";
              components = [
                "rustfmt"
                "rust-src"
                "rust-analyzer"
              ];
            };
          };

          devShells.default = crateOutputs.devShell;
          packages = {
            default = crateOutputs.packages.release;
          };
        };
    };
}
