{ config, pkgs, lib, builtins, catppuccin, ... }:

let conf = import modules/config { inherit lib; };
    linux = (conf.os.type == "linux");
in {
  imports = [
    catppuccin.homeModules.catppuccin

    modules/vim
    modules/alacritty
    modules/firefox
    modules/shell
    modules/dev
    modules/git
    modules/gpg
    modules/ssh
  ] ++ (if linux then [
    modules/podman
    modules/games
    modules/kicad
    modules/weechat
    modules/hyprland
    modules/tofi
  ] else []);

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";

    cache.enable = true;

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

  home.stateVersion = "24.05";
}
