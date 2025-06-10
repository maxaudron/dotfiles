{ config, pkgs, lib, builtins, ... }:

let
  files = lib.mapAttrsToList (name: type: name) (builtins.readDir ./functions);

in {
  programs.zsh.plugins = map (func: {
    name = "functions";
    file = func;
    src = ./functions;
  }) files;
}
