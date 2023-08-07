{ config, pkgs, lib, builtins, ... }:

let conf = import modules/config { inherit lib; };
in {
  imports = [
    modules/doom-emacs
    modules/alacritty
    modules/hyprland
    modules/podman
    modules/shell
    modules/rofi
    modules/tofi
    modules/dev
    modules/git
    modules/gpg
    modules/ssh

    modules/games
    modules/stream

    modules/kicad
    modules/weechat
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
    element-desktop

    unstable.scrcpy
    transmission
  ];

  home.stateVersion = "22.05";
}
