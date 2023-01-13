{ config, lib, pkgs, ... }:

let kicad = pkgs.kicad-small.overrideAttrs (final: prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.jdk17
      ];

      pythonPath = prev.pythonPath ++ [
        pkgs.python3.pkgs.requests
      ];
    });

in { home.packages = [ kicad ]; }
