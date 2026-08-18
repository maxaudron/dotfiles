{ lib, ... }:

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

  catppuccin.cursors.enable = lib.mkForce false;
  services.gpg-agent.enable = lib.mkForce false;

  home.stateVersion = "26.05";
}
