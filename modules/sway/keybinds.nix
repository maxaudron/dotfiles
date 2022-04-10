{ config, lib, pkgs, ... }:

let mod = "Mod4";
in {
  wayland.windowManager.sway.config = {
    keybindings = lib.mkMerge ([{
      # Essentials
      "${mod}+Return" = "exec alacritty";
      "${mod}+r" = "exec rofi -show drun";
      "${mod}+c" = "kill";

      # c floating_modifier "${mod}" normal

      # Exit and reload
      "${mod}+Shift+r" = "reload";

      # Movement
      "${mod}+h" = "focus left";
      "${mod}+j" = "focus down";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";

      "${mod}+Shift+h" = "move left";
      "${mod}+Shift+j" = "move down";
      "${mod}+Shift+k" = "move up";
      "${mod}+Shift+l" = "move right";

      # Layout stuff
      "${mod}+m" = "splith";
      "${mod}+n" = "splitv";

      # Switch the current container between different layout styles
      # bindsym ${mod}+s layout stacking
      # c bindsym "${mod}+w" layout tabbed
      "${mod}+t" = "layout toggle tabbed split";
      "${mod}+f" = "fullscreen";
      "${mod}+s" = "floating toggle";
      "${mod}+space" = "focus mode_toggle";
      "${mod}+a" = "focus parent";

      # Sway has a "scratchpad", which is a bag of holding for windows.
      # You can send windows there and get them back later.

      # Move the currently focused window to the scratchpad
      "${mod}+Shift+minus" = "move scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "${mod}+minus" = "scratchpad show";

    }] ++ (lib.forEach (lib.range 0 9) (i:
      let s = toString i;
      in {
        "${mod}+${s}" = "workspace number ${s}";
        "${mod}+Shift+${s}" = "move container to workspace number ${s}";
      })));
  };
}
