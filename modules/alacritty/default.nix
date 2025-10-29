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
          family = "TX-02";
          style = "Regular";
        };
        bold = {
          family = "TX-02";
          style = "Bold";
        };
        italic = {
          family = "TX-02";
          style = "Oblique";
        };
        bold_italic = {
          family = "TX-02";
          style = "Bold Oblique";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
