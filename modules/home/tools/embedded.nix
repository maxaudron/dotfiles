{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.embedded = {
    enable = lib.mkEnableOption "embedded";
  };

  config = lib.mkIf config.my.tools.embedded.enable {
    home.packages = with pkgs; [
      perf
      blackmagic
      gcc-arm-embedded
      dfu-util
    ];
  };
}
