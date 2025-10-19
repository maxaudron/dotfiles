{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.alacritty = {
    enable = true;
    settings = {
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
