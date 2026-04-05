{
  config,
  lib,
  pkgs,
  ...
}:

let
  kicad = pkgs.master.kicad.overrideAttrs (
    final: prev: {
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
