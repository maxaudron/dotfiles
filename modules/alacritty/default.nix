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
        size = 16;
        normal = {
          family = "Spleen";
          style = "Regular";
        };
        bold = {
          family = "Spleen";
          style = "Regular";
        };
        italic = {
          family = "Spleen";
          style = "Regular";
        };
        bold_italic = {
          family = "Spleen";
          style = "Regular";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
