{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    style = lib.readFile ./style.css;

    settings = [{
      position = "right";
      output = "DP-1";

      modules-left =
        [ "custom/top_edge" "sway/workspaces" "custom/bottom_edge" ];
      modules-right = [ "custom/top_edge" "clock" "custom/bottom_edge" ];

      "custom/bottom_edge" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/top_edge" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };
      "sway/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "";
          urgent = "";
          focused = "";
        };
      };
      clock = {
        format = ''
          {:%H
          %M}'';
      };
    } {
      name = "bottom";
      position = "bottom";
      output = "DP-2";

      margin-bottom = 10;

      modules-right = [ "custom/left_edge" "clock" "custom/right_edge" ];

      "custom/right_edge" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/left_edge" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };
      clock = {
        format = ''{:%H:%M}'';
      };
    }];
  };
}
