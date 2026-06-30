{ inputs, self, ... }:

{
  perSystem =
    { system, pkgs, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          self.overlays.unstable
          self.overlays.master
          self.overlays.mk-luarc
        ];
        config.allowUnfree = true;
      };
    };

  flake = {
    overlays = {
      default = import ../../pkgs;
      unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
      master = final: prev: {
        master = import inputs.nixpkgs-master {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
    };
  };
}
