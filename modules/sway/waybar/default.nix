{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    style = lib.readFile ./style.css;

    settings = [{
      position = "right";

      modules-left =
        [ "custom/top_edge" "sway/workspaces" "custom/bottom_edge" ];
      modules-right = [ "custom/top_edge" "clock" "custom/bottom_edge" ];

      modules = {
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
      };
    }];
  };
}
