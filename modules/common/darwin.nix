{ config, lib, pkgs, ... }:

let conf = import ../config { inherit lib; };
in {
  services.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
  };

  fonts.packages = with pkgs; [ ibm-plex nerdfonts ];

  launchd.user.agents.emacs = {
    serviceConfig.EnvironmentVariables = {
      DOOMDIR =
        config.home-manager.users."${conf.user.name}".home.sessionVariables.DOOMDIR;
      DOOMLOCALDIR =
        config.home-manager.users."${conf.user.name}".home.sessionVariables.DOOMLOCALDIR;
    };
  };
}
