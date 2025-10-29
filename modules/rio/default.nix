{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.rio = {
    enable = true;
    package = pkgs.unstable.rio;
    settings = {
      fonts =
        let
          font = "Monaspace Neon";
        in
        {
          size = 16;

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
            weight = 800;
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
            weight = 800;
          };
        };
    };
  };
}
