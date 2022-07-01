{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";

    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, darwin, home-manager
    , fenix, emacs, hyprland }: {
      nixosConfigurations.liduur = let system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                inherit builtins;
                inherit system;
              };
            };
          }

          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              extraPackages = nixpkgs.lib.mkForce [ ];
            };
          }

          ./machines/liduur/configuration.nix
        ];
      };
      darwinConfigurations.ffma0089 = let system = "aarch64-darwin";
      in darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
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
