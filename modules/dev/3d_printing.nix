{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs;
    [
      prusa-slicer
      unstable.super-slicer-beta
      freecad
    ];
}
