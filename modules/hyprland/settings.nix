{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.windowManager.hyprland.settings = {
    debug = {
      disable_logs = false;
      enable_stdout_logs = true;
    };

    monitor = [
      "DP-1,3840x2160@240,0x0,1"
      "DP-2,2560x1080@60,3840x0,1,transform,3"
    ];

    general = {
      layout = "hy3";

      gaps_in = 10;
      gaps_out = 20;
      border_size = 2;

      "col.inactive_border" = "$mauve";
      "col.active_border" = "$mauve";
      "col.nogroup_border" = "$mauve";
      "col.nogroup_border_active" = "$mauve";

      resize_on_border = true;
    };

    decoration = {
      rounding = 15;
      rounding_power = 2.6;

      shadow = {
        enabled = true;
        range = 14;
        render_power = 3;

        color = "$surface0";
        color_inactive = "$base";
      };
    };

    cursor = {
      hide_on_key_press = true;
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };

    experimental = {
      # Once on NixOS 25.11
      # xx_color_management_v4 = true;
    };

    plugins = {
      hyprsplit = {
        num_workspaces = 5;
        persistent_workspaces = true;
      };

      hy3 = {
        group_inset = 50;

        tabs = {
          height = 42;
          padding = 0;
          radius = 15;
          border_width = 2;

          # active tab bar segment colors
          "col.active" = "$surface0";
          "col.active.border" = "$mauve";
          "col.active.text" = "$mauve";

          # active tab bar segment colors for bars on an unfocused monitor
          "col.active_alt_monitor" = "$surface0";
          "col.active_alt_monitor.border" = "$mauve";
          "col.active_alt_monitor.text" = "$mauve";

          # focused tab bar segment colors (focused node in unfocused container)
          "col.focused" = "$surface0";
          "col.focused.border" = "$surface0";
          "col.focused.text" = "$surface0";

          # inactive tab bar segment colors
          "col.inactive" = "$surface0";
          "col.inactive.border" = "$surface0";
          "col.inactive.text" = "$surface0";

          # urgent tab bar segment colors
          "col.urgent" = "$surface0";
          "col.urgent.border" = "$red";
          "col.urgent.text" = "$red";

          # locked tab bar segment colors
          "col.locked" = "$surface0";
          "col.locked.border" = "$peach";
          "col.locked.text" = "$peach";
        };

        autotile = {
          enable = true;
          trigger_width = 800;
          trigger_height = 500;
        };
      };
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      key_press_enables_dpms = true;
      session_lock_xray = true;
    };

    input = {
      kb_layout = "us";
      kb_options = "compose:rctrl";

      follow_mouse = 1;
      accel_profile = "flat";

      sensitivity = 0.5;
    };

    windowrule = [
      "float, class:imv"
      "float, class:mpv"
    ];

    "$mod" = "SUPER";

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bind = [
      "$mod, return, exec, ghostty"
      "$mod, SPACE, exec, noctalia-shell ipc call launcher toggle"
      "$mod, I, exec, noctalia-shell ipc call controlCenter toggle"
      "$mod, comma, exec, noctalia-shell ipc call settings toggle"
      "$mod, V, exec, qs -c noctalia-shell ipc call launcher clipboard"
      "$mod, U, exec, qs -c noctalia-shell ipc call launcher calculator"
      "$mod, L, exec, qs -c noctalia-shell ipc call lockScreen toggle"

      "$mod, C, hy3:killactive, "
      "$mod, S, togglefloating, "
      "$mod, F, fullscreen, "
      "$mod, T, hy3:changegroup,  toggletab"
      "ALT, tab, hy3:focustab, r, wrap"
      "$mod, e, hy3:changefocus,  raise"
      "$mod+SHIFT, e, hy3:changefocus,  lower"
      "$mod, r, hy3:changegroup,  opposite"

      "$mod, H, hy3:movefocus, l"
      "$mod, J, hy3:movefocus, d"
      "$mod, K, hy3:movefocus, u"
      "$mod, L, hy3:movefocus, r"

      "SUPER_SHIFT, H, hy3:movewindow, l"
      "SUPER_SHIFT, J, hy3:movewindow, d"
      "SUPER_SHIFT, K, hy3:movewindow, u"
      "SUPER_SHIFT, L, hy3:movewindow, r"

      "$mod, n, hy3:makegroup, v"
      "$mod, m, hy3:makegroup, h"

      "$mod, N, layoutmsg, preselect d"
      "$mod, M, layoutmsg, preselect r"

      "$mod, 1, split:workspace, 1"
      "$mod, 2, split:workspace, 2"
      "$mod, 3, split:workspace, 3"
      "$mod, 4, split:workspace, 4"
      "$mod, 5, split:workspace, 5"

      "$mod SHIFT, 1, hy3:movetoworkspace, 1"
      "$mod SHIFT, 2, hy3:movetoworkspace, 2"
      "$mod SHIFT, 3, hy3:movetoworkspace, 3"
      "$mod SHIFT, 4, hy3:movetoworkspace, 4"
      "$mod SHIFT, 5, hy3:movetoworkspace, 5"

      # TeamSpeak AFK / Mute / Silence
      ", code:122, pass, ^(TeamSpeak 3)$"
      ", code:123, pass, ^(TeamSpeak 3)$"
      ", code:121, pass, ^(TeamSpeak 3)$"
    ];
  };
}
