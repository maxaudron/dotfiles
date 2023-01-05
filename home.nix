{ config, pkgs, lib, builtins, ... }:

let conf = import modules/config { inherit lib; };
in {
  imports = [
    modules/doom-emacs
    modules/alacritty
    modules/podman
    modules/shell
    modules/sway
    modules/dev
    modules/mpd
    modules/git
    modules/gpg
    modules/ssh

    modules/games
    modules/stream
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    quasselClient
    imv
    rawtherapee
    davinci-resolve
    blender

    nomachine-client

    nix-index
    yubioath-desktop

    google-chrome
    tdesktop

    kicad-small
    unstable.discord
  ];

  home.stateVersion = "22.05";
}
