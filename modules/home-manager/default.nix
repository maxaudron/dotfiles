{ config, nixpkgs, lib, inputs, system, ... }:

{

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.audron = import ../../home.nix;

    extraSpecialArgs = inputs // {
      inherit builtins;
      inherit system;
    };
  };
}
