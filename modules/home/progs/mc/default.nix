{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.progs.mc = {
    enable = lib.mkEnableOption "mc";
  };

  config = lib.mkIf config.my.progs.mc.enable {
    home.packages = [ pkgs.mc ];
  };
}
