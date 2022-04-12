{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.home.dev.terraform {
    home.packages = [ pkgs.terraform ];
  };
}
