{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
      {
        output = "eDP-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
        bitdepth = "10";
        cm = "dp3";
        vrr = 1;
        # icc = "${../../misc/icc/liduur_dp1.icc}";
      }
    ];
  };
}
