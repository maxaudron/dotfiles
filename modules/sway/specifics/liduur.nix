{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway.config = {
    output = {
      "Goldstar Company Ltd 34GN850 005NTVSHE463" = {
        pos = "0 0";
        mode = "3440x1440@99.982Hz";
      };
      "Goldstar Company Ltd LG ULTRAWIDE 0x00000101" = {
        pos = "450 1440";
        transform = "180";
      };
    };

    defaultWorkspace = "1";
    workspaceOutputAssign = [
      {workspace = "1"; output = "DP-4";}
      {workspace = "2"; output = "DP-4";}
      {workspace = "3"; output = "DP-4";}
      {workspace = "4"; output = "DP-4";}
      {workspace = "5"; output = "DP-4";}

      {workspace = "6"; output = "DP-6";}
      {workspace = "7"; output = "DP-6";}
      {workspace = "8"; output = "DP-6";}
      {workspace = "9"; output = "DP-6";}
      {workspace = "0"; output = "DP-6";}
    ];
  };
}
