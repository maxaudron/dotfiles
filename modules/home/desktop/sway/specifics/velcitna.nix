{ config, lib, pkgs, ... }:

let output = "AU Optronics 0x72A9 Unknown";
in {
  wayland.windowManager.sway.config = {
    output = {
      "${output}" = {
        pos = "0 0";
        mode = "2560x1440@60.000Hz";
        scale = "1.25";
        adaptive_sync = "on";
        render_bit_depth = "10";
        color_profile = "icc ${../../../../../misc/icc/velcitna.icc}";
      };
    };

    defaultWorkspace = "1";
    workspaceOutputAssign = [
      { workspace = "1"; output = "\"${output}\""; }
      { workspace = "2"; output = "\"${output}\""; }
      { workspace = "3"; output = "\"${output}\""; }
      { workspace = "4"; output = "\"${output}\""; }
      { workspace = "5"; output = "\"${output}\""; }
    ];
  };
}
