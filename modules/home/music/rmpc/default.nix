{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.music.rmpc = {
    enable = lib.mkEnableOption "rmpc";
  };

  config = lib.mkIf config.my.music.rmpc.enable {
    programs.rmpc = {
      enable = true;
      package = pkgs.unstable.rmpc;
    };

    xdg.configFile = {
      "rmpc/config.ron".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/mpd/rmpc/config.ron";
      "rmpc/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/mpd/rmpc/themes";
    };
  };
}
