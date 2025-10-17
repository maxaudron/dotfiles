{ config, lib, pkgs, ... }:

let
  conf = import ../config { inherit lib; };
in
{
  config = lib.mkIf (!conf.os.work) {
    home.packages = with pkgs;
      [
        unstable.prusa-slicer
      ];
  };
}
