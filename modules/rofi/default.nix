{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi-wayland
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
