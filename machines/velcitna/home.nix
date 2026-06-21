{ pkgs, ... }:

{
  my = {
    games.enable = true;
    desktop = {
      enable = true;
      sway.enable = true;
    };

    music = {
      mpd.enable = true;
    };

    tools = {
      rust.enable = true;
      wine.enable = true;
    };
  };

  home.packages = [ pkgs.displaycal ];
  home.stateVersion = "25.05";
}
