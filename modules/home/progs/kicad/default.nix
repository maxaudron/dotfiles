{
  config,
  lib,
  pkgs,
  ...
}:

let
  kicad = pkgs.unstable.kicad-small.overrideAttrs (
    final: prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.jdk17
      ];

      pythonPath = prev.pythonPath ++ [
        pkgs.python3.pkgs.requests
      ];
    }
  );

in
{
  options.my.progs.kicad = {
    enable = lib.mkEnableOption "kicad";
  };

  config = lib.mkIf config.my.progs.kicad.enable {
    home.packages = [ kicad ];
  };
}
