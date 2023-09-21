{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    style = lib.readFile ./style.css;

    settings = [
      {
        name = "bottom";
        position = "bottom";
        output = "DP-2";

        margin-left = 10;
        margin-right = 10;
        margin-top = -10;
        margin-bottom = 10;

        "modules-left" = [
          "wlr/workspaces"
        ];
        "modules-right" = [
          "clock"
        ];

        "wlr/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            # active = "";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
          };
          sort-by-number = true;
        };

        clock = {
          format = ''{:%H:%M}'';
        };
      }
    ];
  };
}
