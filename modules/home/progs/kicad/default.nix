{
  config,
  lib,
  pkgs,
  ...
}:

let
  kicad =
    (pkgs.unstable.kicad.overrideAttrs (
      final: prev: {
        pythonPath = prev.pythonPath ++ [
          pkgs.python3.pkgs.requests
        ];
      }
    )).override
      {
        # addons = with pkgs.unstable.kicadAddons; [ kikit ];
      };
in
{
  options.my.progs.kicad = {
    enable = lib.mkEnableOption "kicad";
  };

  config = lib.mkIf config.my.progs.kicad.enable {
    home.packages = [
      kicad
      # pkgs.unstable.kikit
    ];
  };
}
