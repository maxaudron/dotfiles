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
          font = "TX-02";
        in
        {
          size = 19;

          regular = {
            family = font;
            style = "Normal";
            width = "Condensed";
            weight = 375;
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
            weight = 375;
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
