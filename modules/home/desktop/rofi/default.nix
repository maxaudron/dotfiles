{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.desktop.rofi = {
    enable = lib.mkEnableOption "rofi";
  };

  config = lib.mkIf config.my.desktop.rofi.enable {
    home.packages = with pkgs; [
      rofi
    ];

    xdg = {
      configFile = {
        "rofi/config.rasi" = {
          source = ./config.rasi;
        };
        "rofi/themes" = {
          source = ./themes;
        };
      };
    };
  };
}
