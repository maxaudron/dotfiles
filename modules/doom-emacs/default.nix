{ pkgs, config, lib, system, emacs, ... }:

with lib;

let
  conf = import ../config { inherit lib; };
  emacsPackage = if /*pkgs.stdenv.isLinux*/ false then
    emacs.packages.${system}.emacsPgtkNativeComp
  else
    pkgs.emacs28NativeComp;
in {
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.home.homeDirectory}/.local/doom";
    };

    file = {
      ".vale.ini".text = ''
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
  };

  xdg = {
    enable = true;
    configFile = {
      "doom" = {
        source = pkgs.symlinkJoin {
          name = "doom";
          paths = [
            ./files
            (pkgs.runCommand "secrets" { } ''
              mkdir -p $out
              ln -s ${config.home.homeDirectory}/.dotfiles/secrets/.config/doom/secrets $out/secrets
            '')
          ];
        };
        onChange = "${pkgs.writeShellScript "doom-config-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH=$PATH:${emacsPackage}/bin
          ${config.xdg.configHome}/emacs/bin/doom --force sync
        ''}";
      };
      "emacs" = {
        source = builtins.fetchGit {
          url = "https://github.com/doomemacs/doomemacs";
          ref = "master";
          rev = "33c5f3721a704c72e49efc5960be3785d1a80b81";
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
