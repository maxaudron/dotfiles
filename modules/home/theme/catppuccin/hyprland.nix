{ lib, config, ... }:

let
  l = lib.generators.mkLuaInline;
  accent = config.catppuccin.accent;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf config.my.desktop.hyprland.enable {
    config = {
      plugin = {
        hy3 = {
          tabs = {
            colors = {
              # active tab bar segment colors
              active = l "colors.surface0";
              active_border = l "colors.${accent}";
              active_text = l "colors.${accent}";

              # active tab bar segment rs for bars on an unfocused monitor
              active_alt_monitor = l "colors.surface0";
              active_alt_monitor_border = l "colors.${accent}";
              active_alt_monitor_text = l "colors.${accent}";

              # focused tab bar segment rs (focused node in unfocused container)
              focused = l "colors.surface0";
              focused_border = l "colors.surface0";
              focused_text = l "colors.text";

              # inactive tab bar segment rs
              inactive = l "colors.surface0";
              inactive_border = l "colors.surface0";
              inactive_text = l "colors.text";

              # urgent tab bar segment rs
              urgent = l "colors.surface0";
              urgent_border = l "colors.red";
              urgent_text = l "colors.red";

              # locked tab bar segment rs
              locked = l "colors.surface0";
              locked_border = l "colors.peach";
              locked_text = l "colors.peach";
            };
          };
        };
      };

      general = {
        col = {
          inactive_border = l "colors.surface0";
          active_border = l "colors.${accent}";
          nogroup_border = l "colors.surface0";
          nogroup_border_active = l "colors.${accent}";
        };
      };
    };
  };
}
