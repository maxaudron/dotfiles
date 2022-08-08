{ config, lib, pkgs, ... }:

let mod = "Mod4";
in {
  wayland.windowManager.sway.config = {
    keybindings = lib.mkMerge ([{
      # Essentials
      "${mod}+Return" = "exec alacritty";
      "${mod}+r" = "exec rofi -show drun";
      "${mod}+c" = "kill";

      "XF86AudioLowerVolume" = "exec xdotool keydown XF86AudioLowerVolume";
      "--release --locked XF86AudioLowerVolume" = "exec xdotool keyup XF86AudioLowerVolume";

      "XF86AudioRaiseVolume" = "exec xdotool keydown XF86AudioRaiseVolume";
      "--release --locked XF86AudioRaiseVolume" = "exec xdotool keyup XF86AudioRaiseVolume";

      "XF86AudioMute" = "exec xdotool keydown XF86AudioMute";
      "--release --locked XF86AudioMute" = "exec xdotool keyup XF86AudioMute";

      "Control+Mod4+Mod1+Shift+1" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 1";
      "--release --locked Control+Mod4+Mod1+Shift+1" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 1";
      "Control+Mod4+Mod1+Shift+2" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 2";
      "--release --locked Control+Mod4+Mod1+Shift+2" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 2";
      "Control+Mod4+Mod1+Shift+3" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 3";
      "--release --locked Control+Mod4+Mod1+Shift+3" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 3";
      "Control+Mod4+Mod1+Shift+4" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 4";
      "--release --locked Control+Mod4+Mod1+Shift+4" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 4";
      "Control+Mod4+Mod1+Shift+5" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 5";
      "--release --locked Control+Mod4+Mod1+Shift+5" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 5";
      "Control+Mod4+Mod1+Shift+6" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 6";
      "--release --locked Control+Mod4+Mod1+Shift+6" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 6";
      "Control+Mod4+Mod1+Shift+7" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 7";
      "--release --locked Control+Mod4+Mod1+Shift+7" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 7";
      "Control+Mod4+Mod1+Shift+8" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 8";
      "--release --locked Control+Mod4+Mod1+Shift+8" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 8";
      "Control+Mod4+Mod1+Shift+9" = "exec xdotool keydown ctrl keydown super keydown alt keydown shift keydown 9";
      "--release --locked Control+Mod4+Mod1+Shift+9" = "exec xdotool keyup ctrl keydown super keydown alt keydown shift keydown 9";

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
