{ pkgs, config, lib, system, ... }:

with lib;

let conf = import ../config { inherit lib; };
in {
  home.packages = with pkgs; [ unstable.zed-editor ];

  xdg = {
    enable = true;
    configFile = {
      "zed/settings.json" = lib.mkIf (!conf.os.work) {
        source = ./settings.json;
      };
      "zed/keymap.json" = {
        source = ./keymap.json;
      };
    };
  };
}
