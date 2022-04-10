{ config, lib, pkgs, ... }:

let
  c1 = "#fd472f";
  c2 = "#e88a30";
  c3 = "#99a2ea";
  c4 = "#242424";
  c5 = "#242424";

  white = "#f4f4f8";
  dark = "#181818";
  dim = "#242424";

in {
  wayland.windowManager.sway.config = {
    output = {
      "*" = {
        bg = "${../../wallpaper/blade_runner/mpv-shot0003.jpg} fill";
      };
    };

    gaps = {
      inner = 10;
      outer = 0;
      smartGaps = false;
      smartBorders = "off";
    };

    window = {
      titlebar = false;
      border = 2;
      hideEdgeBorders = "smart";
    };

    colors = {
      background = dark;
      # statusline = "#ffffff";
      # separator = "#666666";
      focused = {
        border = c2;
        background = c2;
        text = dark;
        indicator = c3;
        childBorder = c2;
      };
      focusedInactive = {
        border = c5;
        background = c5;
        text = white;
        indicator = c5;
        childBorder = c5;
      };
      unfocused = {
        border = c4;
        background = c4;
        text = dim;
        indicator = c5;
        childBorder = c4;
      };
      urgent = {
        border = c1;
        background = c1;
        text = c4;
        indicator = c3;
        childBorder = c1;
      };
    };

    bars = lib.mkForce [];
  };
}
