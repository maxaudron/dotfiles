{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf config.my.tools.printing.enable {
    home.packages = with pkgs; [
      unstable.prusa-slicer
    ];
  };
}
