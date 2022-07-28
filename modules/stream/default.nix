{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    obs-studio
    obs-studio-plugins.looking-glass-obs
    looking-glass-client
  ];
}
