{ config, pkgs, lib, builtins, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
    conf = import modules/config { inherit lib; };
in {
  imports = [
    modules/doom-emacs
    modules/alacritty
    modules/shell
    modules/sway
    modules/dev
    modules/git
    modules/gpg
    modules/podman
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    quasselClient

    unstable.teamspeak_client
  ];

  home.stateVersion = "21.11";
}
