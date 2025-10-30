{
  config,
  lib,
  pkgs,
  ...
}:

let
  conf = import ../config { inherit lib; };
  linux = conf.os.type == "linux";
in
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

      font =
        let
          font = "TX-02-Variable";
        in
        {
          size = 14;
          builtin_box_drawing = false;
          normal = {
            family = font;
            style = "Retina";
          };
          bold = {
            family = font;
            style = "SemiBold";
          };
          italic = {
            family = font;
            style = "Oblique";
          };
          bold_italic = {
            family = font;
            style = "SemiBold Oblique";
          };
        };

      colors = {
        draw_bold_text_with_bright_colors = false;
      };
    };
  };

  programs.ghostty = {
    enable = true;
    package = if linux then pkgs.ghostty else null;
    enableFishIntegration = true;

    settings = let 
      wdth = "80";
      reg = "400";
      bold = "600";
    in {
      font-family = "TX-02-Variable";
      font-size = 14;

      font-variation = [ "wdth=${wdth}" "wght=${reg}" "slnt=0" ];
      font-variation-bold = [ "wdth=${wdth}" "wght=${bold}" "slnt=0" ];
      font-variation-italic = [ "wdth=${wdth}" "wght=${reg}" "slnt=-16" ];
      font-variation-bold-italic = [ "wdth=${wdth}" "wght=${bold}" "slnt=-16" ];

      # calt: Enable ligatures
      # salt / aalt: Enable all the below and break == and === ligatures
      # ss01: Dashed Zero
      # ss02: Dotted Zero
      # ss03: Gapped Zero
      # ss04: Dashed Seven
      # ss05: Rounded r
      # ss06: Broken Bar
      font-feature = [ "+liga" "+calt" "+ss03" "+ss06" ];
      freetype-load-flags = [ "no-hinting" ];
    };
  };

  programs.rio = {
    enable = true;
    package = pkgs.unstable.rio;
    settings = {
      fonts =
        let
          font = "TX-02-Variable";
        in
        {
          size = 19;
          extras = [
            { family = "Symbols Nerd Font Mono"; }
            { family = "Twitter Color Emoji"; }
          ];

          features = [ "liga" "calt" "ss03" "ss06" ];
          hinting = false;
          use-drawable-chars = false;

          regular = {
            family = font;
            style = "Normal";
            width = "Normal";
            weight = 400;
          };
          bold = {
            family = font;
            style = "Normal";
            width = "Normal";
            weight = 600;
          };
          italic = {
            family = font;
            style = "Italic";
            width = "Normal";
            weight = 400;
          };
          bold-italic = {
            family = font;
            style = "Italic";
            width = "Normal";
            weight = 600;
          };
        };
    };
  };
}
