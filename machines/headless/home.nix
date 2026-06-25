{ ... }:

{
  my = {
    desktop = {
      enable = false;
    };

    music = {
      mpd.enable = false;
      beets.enable = false;
    };

    tools = {
      rust.enable = true;
    };
  };

  home.stateVersion = "26.05";
}
