{ config, pkgs, lib, builtins, catppuccin, ... }:

let conf = import modules/config { inherit lib; };
    linux = (conf.os.type == "linux");
in {
  imports = [
    catppuccin.homeModules.catppuccin

    modules/vim
    modules/alacritty
    modules/rio
    modules/firefox
    modules/shell
    modules/dev
    modules/git
    modules/gpg
    modules/ssh
    modules/mc
  ] ++ (if linux then [
    modules/podman
    modules/games
    modules/kicad
    modules/weechat
    modules/hyprland
    modules/mpd
  ] else []);

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  catppuccin = {
    enable = true;
    flavor = "mocha";

    firefox.force = true;
    cursors = {
      enable = linux;
      accent = "dark";
    };
  };

  home.packages = with pkgs; [
    nix-index

    google-chrome
    youtube-music
  ] ++ (if linux then [
    quasselClient

    discord
    teamspeak3

    hledger
    hledger-web
  ] else []);

  programs.imv.enable = linux;
  programs.mpv.enable = true;
  programs.tmux.enable = true;

  home.stateVersion = "25.05";
}
