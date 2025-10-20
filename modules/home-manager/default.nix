{ config, nixpkgs, lib, inputs, system, ... }:

let
  conf = import ../../modules/config { inherit lib; };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${conf.user.name}" = import ../../home.nix;

    extraSpecialArgs = inputs // {
      inherit builtins;
      inherit system;
    };
  };
}
