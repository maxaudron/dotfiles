{ kintree, system, ... }:

{
  my = {
    games.enable = true;
    desktop = {
      enable = true;
      hyprland.enable = true;
    };

    music = {
      mpd.enable = true;
      beets.enable = true;
    };

    tools = {
      printing.enable = true;
      rust.enable = true;
      latex.enable = true;
      labels.enable = true;
    };

    progs = {
      kicad.enable = true;
      mail.enable = true;
      opencode.enable = true;
    };
  };

  # home.packages = [ kintree.packages.${system}.default ];
  home.stateVersion = "26.05";
}
