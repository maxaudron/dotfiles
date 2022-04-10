{ config, pkgs, lib, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.audron = import ../../home.nix;

  home-manager.extraSpecialArgs = { inherit builtins; };
}
