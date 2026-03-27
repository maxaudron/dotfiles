{ pkgs, ... }:

{
  home.packages = [ pkgs.displaycal ];
  my = {
    desktop = {
      enable = true;
      sway.enable = true;
    };

    music = {
      mpd.enable = true;
    };

    tools = {
      rust.enable = true;
    };
  };
}
