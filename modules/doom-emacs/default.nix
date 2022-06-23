{ pkgs, config, lib, ... }:

with lib;

let
  conf = import ../config { inherit lib; };
  emacsPackage =
    if pkgs.stdenv.isLinux then pkgs.emacsPgtkNativeComp else pkgs.emacs28NativeComp;
in {
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.home.homeDirectory}/.local/doom";
    };

    file.".vale.ini".text = ''
      StylesPath = .local/share/vale/styles

      MinAlertLevel = suggestion
      Vocab = Base

      Packages = Google, write-good

      [*]
      BasedOnStyles = Vale, Google, write-good
      Annotations    = suggestion
      ComplexWords   = NO
      Editorializing = warning
      GenderBias     = suggestion
      Hedging        = NO
      Litotes        = suggestion
      PassiveVoice   = NO
      Redundancy     = error
      Repetition     = error
      Uncomparables  = error
      Wordiness      = warning
    '';
  };

  xdg = {
    enable = true;
    configFile = {
      "doom" = {
        source = ./files;
        onChange = "${pkgs.writeShellScript "doom-config-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          ${config.xdg.configHome}/emacs/bin/doom --force sync
        ''}";
      };
      "emacs" = {
        source = pkgs.fetchFromGitHub {
          owner = "doomemacs";
          repo = "doomemacs";
          rev = "master";
          hash = "sha256:NybDqJ+fNFNlQhSP+mrUnsXwhsYiZHjK9H5SxLC9fg4=";
        };
        onChange = "${pkgs.writeShellScript "doom-emacs-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom --force install
          else
            ${config.xdg.configHome}/emacs/bin/doom --force sync -u
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

    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US

    vale
  ];
}
