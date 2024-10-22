{ config, lib, pkgs, nixpkgs-master, system, secrets, ... }:

let
  factorio = pkgs.master.factorio-space-age.override
    (lib.importTOML ("${secrets}" + "/factorio.toml"));
in
{
  home.packages = [ factorio pkgs.starsector pkgs.prismlauncher ];
}
