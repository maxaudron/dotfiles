{ config, lib, pkgs, nixpkgs-master, system, secrets, ... }:

let
  factorio = pkgs.unstable.factorio.override
    (lib.importTOML ("${secrets}" + "/factorio.toml"));
in { home.packages = [ factorio ]; }
