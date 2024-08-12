{ pkgs, config, lib, system, ... }:

with lib;

{
  home.packages = with pkgs; [ unstable.zed-editor ];

  xdg = {
    enable = true;
    configFile = {
      "zed/settings.json" = {
        source = ./settings.json;
      };
      "zed/keymap.json" = {
        source = ./keymap.json;
      };
    };
  };
}
