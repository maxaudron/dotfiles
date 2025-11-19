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
  programs.ghostty = {
    enable = true;
    package = if linux then pkgs.ghostty else pkgs.ghostty-bin;
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
}
