{
  config,
  lib,
  pkgs,
  ...
}:

let catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "alacritty";
        rev = "343cf8d";
        hash = "sha256-5MUWHXs8vfl2/u6YXB4krT5aLutVssPBr+DiuOdMAto=";
    };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "${catppuccin}/catppuccin-mocha.toml" ];

      keyboard.bindings = [
        {
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];

      env = {
        TERM = "xterm-256color";
      };

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

      colors = {
        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
