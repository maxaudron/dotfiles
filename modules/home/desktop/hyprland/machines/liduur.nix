{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
      {
        output = "DP-1";
        mode = "3840x2160@240";
        position = "0x0";
        scale = 1;
        bitdepth = "10";
        cm = "dp3";
        vrr = 1;
        # icc = "${../../misc/icc/liduur_dp1.icc}";
      }
      {
        output = "DP-2";
        mode = "2560x1080@60";
        position = "3840x0";
        scale = 1;
        transform = 3;
      }
    ];
  };
}
