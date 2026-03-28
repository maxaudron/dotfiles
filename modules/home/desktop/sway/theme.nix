{ lib, ... }:

{
  wayland.windowManager.sway.config = {
    output = {
      "*" = {
        bg = "${../../../../misc/wallpaper/evening-sky.png} fill";
      };
    };

    gaps = {
      inner = 20;
      outer = 0;
      smartGaps = false;
      smartBorders = "off";
    };

    window = {
      titlebar = false;
      border = 2;
      hideEdgeBorders = "smart";
    };

    bars = lib.mkForce [ ];
  };
}
