{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    secrets = {
      url = "git+ssh://audron@audron.dev:/home/audron/secrets.git";
      flake = false;
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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

    catppuccin.url = "github:catppuccin/nix/release-26.05";
    textfox.url = "github:adriankarlen/textfox";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beets-rockbox = {
      url = "github:maxaudron/beets-rockbox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kintree = {
      url = "github:maxaudron/nixos-kintree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./modules/flake/lib.nix
        ./modules/flake/luarc.nix
        ./modules/flake/overlays.nix
        ./modules/flake/packages.nix
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          formatter = pkgs.nixfmt-tree;
        };

      flake = {
        nixosModules = import ./modules/nixos { inherit (nixpkgs) lib; };
        darwinModules = import ./modules/darwin { inherit (nixpkgs) lib; };

        homeModules.default = import ./modules/home;
        homeConfigurations.default = self.lib.mkHomeConfig "headless" "x86_64-linux";

        nixosConfigurations.liduur = self.lib.mkSystem "liduur" "x86_64-linux";
        nixosConfigurations.velcitna = self.lib.mkSystem "velcitna" "x86_64-linux";
        darwinConfigurations.ffma0089 = self.lib.mkSystem "ffma0089" "aarch64-darwin";
      };
    };
}
