{ config, pkgs, lib, builtins, ... }:

let conf = import modules/config { inherit lib; };
in {
  imports = [
    modules/doom-emacs
    modules/zed

    modules/alacritty
    modules/podman
    modules/shell
    modules/dev
    modules/git
    modules/gpg
    modules/ssh

    modules/games

    modules/kicad
    modules/weechat
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = false;

  home.packages = with pkgs; [
    alacritty
    grim
    slurp
    mpv

    quasselClient
    imv
    rawtherapee
    blender
    inkscape

    nix-index

    google-chrome
    tdesktop
    discord
    teamspeak_client

    unstable.scrcpy
    transmission
  ];

  home.stateVersion = "24.05";
}
