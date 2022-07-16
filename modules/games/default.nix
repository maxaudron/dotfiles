{ config, lib, pkgs, nixpkgs-master, system, ... }:

let factorio = pkgs.master.factorio.override {
      username = "anymax";
      token = "e572bb639cecdfa8190a3b46860190";
    };
in {
  home.packages = [ factorio ];
}
