{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway.config = {
    input = {
      "type:keyboard" = {
        xkb_layout = "us";
        xkb_options = "compose:rctrl";
        xkb_numlock = "enabled";
      };
      "1149:32792:Kensington_Expert_Wireless_TB_Mouse" = {
        accel_profile = "adaptive";
        pointer_accel = "0.5";
        scroll_factor = "0.5";
      };
    };
  };
}
