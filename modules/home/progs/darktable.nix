{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.progs.darktable = {
    enable = lib.mkEnableOption "darktable";
  };

  config = lib.mkIf config.my.progs.darktable.enable {
    home.packages = [ pkgs.darktable ];
  };
}
