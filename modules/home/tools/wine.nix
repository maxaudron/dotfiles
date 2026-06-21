{ lib, config, pkgs, ... }:

{
  options.my.tools.wine = {
    enable = lib.mkEnableOption "wine";
  };

  config = lib.mkIf config.my.tools.wine.enable {

    home.packages = with pkgs; [
      wine64
      winetricks
    ];
  };
}
