{ config, pkgs, lib, builtins, ... }:

let
  files = lib.mapAttrsToList (name: type: name) (builtins.readDir ./functions);

in {
  programs.zsh.plugins = map (func: {
    name = "functions";
    file = func;
    src = ./functions;
  }) files;
  
  # programs.fish.functions = (acc: elem: { "${elem}" = lib.readFile "./functions/${elem}"; } // acc) {} files;
  programs.fish.functions = builtins.mapAttrs (name: type: (lib.readFile (./functions + "/${name}"))) (builtins.readDir ./functions);
}
