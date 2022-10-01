{ config, lib, pkgs, nixpkgs-master, system, ... }:

let
  nixpkgs = import (fetchTarball {
    url = "https://github.com/leifhelm/nixpkgs/archive/factorio.tar.gz";
    sha256 = "0qrrg2i9l05i6ig7969wj1r1ccddb7na2486355410ci75xh4sy7";
  });
  pkgs = nixpkgs {
    system = system;
    config.allowUnfree = true;
  };
  factorio = pkgs.factorio.override {
    username = "anymax";
    token = "e572bb639cecdfa8190a3b46860190";
  };
in { home.packages = [ factorio ]; }
