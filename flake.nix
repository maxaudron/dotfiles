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
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      darwin,
      home-manager,
      catppuccin,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake =
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
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                overlay-unstable
                overlay-master
                (import ./pkgs)
              ];
            };

          mkSystemCmd =
            system:
            if nixpkgs.lib.strings.hasSuffix "-linux" system then
              nixpkgs.lib.nixosSystem
            else
              darwin.lib.darwinSystem;

          mkSystem =
            name: system: modules:
            mkSystemCmd system {
              inherit system;
              specialArgs = specialArgs // {
                inherit system;
                machineName = name;
              };
              modules = [
                overlays
                ./machines/${name}/configuration.nix
              ]
              ++ modules;
            };

          linuxModules = [
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            self.nixosModules.default
          ];

          darwinModules = [
            home-manager.darwinModules.home-manager
            self.darwinModules.default
          ];
        in
        {
          nixosModules = import ./modules/nixos { inherit (nixpkgs) lib; };
          darwinModules = import ./modules/darwin { inherit (nixpkgs) lib; };

          homeModules.default = import ./modules/home;
          homeConfigurations.default =
            let
              system = "x86_64-linux";
              machineName = "headless";
            in
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              extraSpecialArgs = inputs // {
                inherit builtins system machineName;
              };
              modules = [
                overlays
                self.homeModules.default
              ];
            };

          nixosConfigurations.liduur = mkSystem "liduur" "x86_64-linux" linuxModules;
          nixosConfigurations.velcitna = mkSystem "velcitna" "x86_64-linux" linuxModules;
          darwinConfigurations.ffma0089 = mkSystem "ffma0089" "aarch64-darwin" darwinModules;
        };

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./pkgs) ];
            config.allowUnfree = true;
          };

          formatter = pkgs.nixfmt-tree;

          packages =
            (import ./pkgs pkgs pkgs)
            // (
              let
                qmk_redox = pkgs.callPackage ./misc/qmk;
              in
              {
                redox_left = qmk_redox { left = true; };
                redox_right = qmk_redox { left = false; };
              }
            );

          apps = {
            flash_redox_left = (
              import ./misc/qmk/flash.nix {
                inherit pkgs;
                firmware = self'.packages.redox_left;
              }
            );
            flash_redox_right = (
              import ./misc/qmk/flash.nix {
                inherit pkgs;
                firmware = self'.packages.redox_right;
              }
            );
          };
        };
    };
}
