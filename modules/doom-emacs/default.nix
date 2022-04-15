{ pkgs, config, lib, ... }:

with lib;

let
  conf = lib.importTOML ../../config.toml;
  emacsPackage =
    if pkgs.stdenv.isLinux then pkgs.emacsPgtkGcc else pkgs.emacs;
in {
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.home.homeDirectory}/.local/doom";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom" = {
        source = ./files;
        onChange = "${pkgs.writeShellScript "doom-config-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          ${config.xdg.configHome}/emacs/bin/doom -y sync
        ''}";
      };
      "emacs" = {
        source = fetchGit "https://github.com/hlissner/doom-emacs";
        onChange = "${pkgs.writeShellScript "doom-emacs-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };

  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    package = emacsPackage;
  };

  home.packages = with pkgs; [
    fd
    zstd
    gnutls
    binutils
    imagemagick
    editorconfig-core-c
    emacs-all-the-icons-fonts
    (ripgrep.override { withPCRE2 = true; })
  ];
}
