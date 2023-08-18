{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.alacritty ];

  xdg = {
    enable = true;
    configFile = {
      "alacritty/alacritty.yml".text = builtins.toJSON {
        window = { decoration = "none"; };

        key_bindings = [{
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }];

        env = { TERM = "xterm-256color"; };

        font = {
          size = 13;
          normal = {
            family = "IBM Plex Mono";
            style = "Regular";
          };
          bold = {
            family = "IBM Plex Mono";
            style = "Regular";
          };
          italic = {
            family = "IBM Plex Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "IBM Plex Mono";
            style = "Bold Italic";
          };
        };

        draw_bold_text_with_bright_colors = false;

        colors = {
          # Default colors
          primary = {
            background = "0x181818";
            foreground = "0xc5c8c6";
          };

          # Normal colors
          normal = {
            black = "0x1d1f21";
            red = "0xcc6666";
            green = "0xb5bd68";
            yellow = "0xedbf66";
            blue = "0x81a2be";
            magenta = "0xb294bb";
            cyan = "0x8abeb7";
            white = "0xc5c8c6";
          };

          # Bright colors
          bright = {
            black = "0x969896";
            red = "0xcc6666";
            green = "0xb5bd68";
            yellow = "0xedbf66";
            blue = "0x81a2be";
            magenta = "0xb294bb";
            cyan = "0x8abeb7";
            white = "0xffffff";
          };
        };
      };
    };
  };
}
