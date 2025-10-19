{ config, pkgs, lib, builtins, catppuccin, ... }:

let conf = import modules/config { inherit lib; };
in {
  imports = [
    catppuccin.homeModules.catppuccin

    # modules/doom-emacs
    # modules/zed
    modules/vim

    modules/alacritty
    modules/firefox
    modules/podman
    modules/shell
    modules/dev
    modules/git
    modules/gpg
    modules/ssh

    modules/games

    modules/kicad
    modules/weechat

    modules/hyprland
    modules/tofi
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = false;

  catppuccin = {
    enable = true;
    flavor = "mocha";

    cache.enable = true;

    firefox.force = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
  };

  home.packages = with pkgs; [
    alacritty
    grim
    slurp

    quasselClient
    rawtherapee
    blender

    nix-index

    google-chrome
    tdesktop
    discord
    teamspeak3

    unstable.scrcpy
    youtube-music
    solvespace
    freecad

    savvycan

    hledger
    hledger-web
  ];

  programs.imv.enable = true;
  programs.mpv.enable = true;

  home.stateVersion = "24.05";
}
