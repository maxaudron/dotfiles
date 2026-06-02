{
  withSystem,
  inputs,
  darwin,
  self,
  ...
}:

{

  flake = {
    lib = {
      specialArgs = inputs // {
        inherit inputs;
      };

      mkSystemCmd =
        system:
        if inputs.nixpkgs.lib.strings.hasSuffix "-linux" system then
          inputs.nixpkgs.lib.nixosSystem
        else
          inputs.darwin.lib.darwinSystem;

      mkSystem =
        name: system:
        withSystem system (
          { pkgs, system, ... }:
          self.lib.mkSystemCmd system {
            inherit system;
            specialArgs = self.lib.specialArgs // {
              inherit system;
              machineName = name;
            };
            modules = [
              ../../machines/${name}/configuration.nix
              { nixpkgs.pkgs = pkgs; }
            ]
            ++ (
              if inputs.nixpkgs.lib.strings.hasSuffix "-linux" system then
                self.lib.linuxModules
              else
                self.lib.darwinModules
            );
          }
        );

      linuxModules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.catppuccin.nixosModules.catppuccin
        self.nixosModules.default
      ];

      darwinModules = [
        inputs.home-manager.darwinModules.home-manager
        self.darwinModules.default
      ];
    };
  };
}
