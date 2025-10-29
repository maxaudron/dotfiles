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
        size = 14;
        normal = {
          family = "TX-02";
          style = "Regular";
        };
        bold = {
          family = "TX-02";
          style = "SemiBold";
        };
        italic = {
          family = "TX-02";
          style = "Oblique";
        };
        bold_italic = {
          family = "TX-02";
          style = "SemiBold Oblique";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
