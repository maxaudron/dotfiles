{ config, lib, pkgs, ... }:

let
  displayRight ="LG Electronics LG ULTRAWIDE 0x01010101";
  displayLeft = "Samsung Electric Company Odyssey G8 HNTT600109";
in {
  wayland.windowManager.sway.config = {
    output = {
      "${displayLeft}" = {
        pos = "0 0";
        mode = "3840x2160@240.000Hz";
        adaptive_sync = "on";
        render_bit_depth = "10";
        color_profile = "icc ${../../../../../misc/icc/liduur_dp1.icc}";
      };
      "${displayRight}" = {
        pos = "3840 -400";
        mode = "2560x1080@60.000Hz";
        transform = "90";
        color_profile = "icc ${../../../../../misc/icc/liduur_dp2.icc}";
      };
    };

    defaultWorkspace = "1";
    workspaceOutputAssign = [
      { workspace = "1"; output = "\"${displayLeft}\""; }
      { workspace = "2"; output = "\"${displayLeft}\""; }
      { workspace = "3"; output = "\"${displayLeft}\""; }
      { workspace = "4"; output = "\"${displayLeft}\""; }
      { workspace = "5"; output = "\"${displayLeft}\""; }

      { workspace = "6"; output = "\"${displayRight}\""; }
      { workspace = "7"; output = "\"${displayRight}\""; }
      { workspace = "8"; output = "\"${displayRight}\""; }
      { workspace = "9"; output = "\"${displayRight}\""; }
      { workspace = "0"; output = "\"${displayRight}\""; }
    ];
  };
}
