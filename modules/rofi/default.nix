{ config, lib, pkgs, ... }:

{
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
}
