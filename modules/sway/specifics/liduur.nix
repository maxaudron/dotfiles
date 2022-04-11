{ config, lib, pkgs, ... }:

let
  displayTop ="Goldstar Company Ltd 34GN850 005NTVSHE463";
  displayBottom = "Goldstar Company Ltd LG ULTRAWIDE 0x00000101";
in {
  wayland.windowManager.sway.config = {
    output = {
      "${displayTop}" = {
        pos = "0 0";
        mode = "3440x1440@99.982Hz";
      };
      "${displayBottom}" = {
        pos = "450 1440";
        transform = "180";
      };
    };

    defaultWorkspace = "1";
    workspaceOutputAssign = [
      { workspace = "1"; output = "\"${displayTop}\""; }
      { workspace = "2"; output = "\"${displayTop}\""; }
      { workspace = "3"; output = "\"${displayTop}\""; }
      { workspace = "4"; output = "\"${displayTop}\""; }
      { workspace = "5"; output = "\"${displayTop}\""; }

      { workspace = "6"; output = "\"${displayBottom}\""; }
      { workspace = "7"; output = "\"${displayBottom}\""; }
      { workspace = "8"; output = "\"${displayBottom}\""; }
      { workspace = "9"; output = "\"${displayBottom}\""; }
      { workspace = "0"; output = "\"${displayBottom}\""; }
    ];
  };
}
