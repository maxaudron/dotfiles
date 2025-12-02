{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    secrets = {
      url = "git+ssh://audron@audron.dev:/home/audron/secrets.git";
      flake = false;
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    catppuccin.url = "github:catppuccin/nix/main";
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
  };

  outputs =
    inputs@{
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
                home-manager.nixosModules.home-manager
                catppuccin.nixosModules.catppuccin
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

          packages = (import ./pkgs pkgs pkgs);
        };
    };
}

