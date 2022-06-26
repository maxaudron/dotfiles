{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";
    # wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, fenix, emacs }: {
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
              users.audron = import ./home.nix;
            };
          }
          ./machines/liduur/configuration.nix
        ];
      };
    };
}
