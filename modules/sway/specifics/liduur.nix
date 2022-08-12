{ config, lib, pkgs, ... }:

let
  displayRight ="Goldstar Company Ltd 34GN850 005NTVSHE463";
  displayLeft = "Samsung Electric Company Odyssey G8 HNTT600109";
in {
  wayland.windowManager.sway.config = {
    output = {
      "${displayRight}" = {
        pos = "3840 0";
        mode = "3440x1440@143.923Hz";
        transform = "270";
      };
      "${displayLeft}" = {
        pos = "0 0";
        mode = "3840x2160@120.000Hz";
        # transform = "180";
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
