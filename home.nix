{ config, pkgs, lib, builtins, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [ modules/doom-emacs modules/alacritty modules/shell modules/sway ];

  home.username = "audron";
  home.homeDirectory = "/home/audron";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    unstable.quasselClient
  ];

  home.stateVersion = "21.11";
}
