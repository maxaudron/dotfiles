{ config, pkgs, lib, builtins, ... }:

with lib;

let
  conf = lib.importTOML ../../config.toml;
in {
  imports = [
    ../../modules/doom-emacs
    ../../modules/alacritty
    ../../modules/shell
    ../../modules/git
    ../../modules/gpg
    ../../modules/dev
  ];

  home.username = conf.user.name;
  home.homeDirectory = lib.mkForce conf.user.home;

  programs.home-manager.enable = true;

  programs.gpg.scdaemonSettings = { disable-ccid = true; };

  home.packages = with pkgs; [ pass ];

  home.stateVersion = "21.11";
}
