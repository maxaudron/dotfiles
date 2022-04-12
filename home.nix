{ config, pkgs, lib, builtins, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [
    modules/doom-emacs
    modules/alacritty
    modules/shell
    modules/sway
    modules/dev
    modules/git
    modules/gpg
  ];

  home.username = "audron";
  home.homeDirectory = "/home/audron";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    quasselClient

    unstable.teamspeak_client
  ];

  home.stateVersion = "21.11";
}
