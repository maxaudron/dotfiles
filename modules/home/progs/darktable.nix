{
  config,
  lib,
  pkgs,
  ...
}:

let
  opencv5 = pkgs.unstable.callPackage ../../../pkgs/spectral_film_lut/opencv5 { };
  spectral_film_lut = pkgs.unstable.python3Packages.callPackage ../../../pkgs/spectral_film_lut {
    inherit opencv5;
  };
in
{
  options.my.progs.darktable = {
    enable = lib.mkEnableOption "darktable";
  };

  config = lib.mkIf config.my.progs.darktable.enable {
    home.packages = with pkgs; [
      darktable
      spectral_film_lut
    ];
  };
}
