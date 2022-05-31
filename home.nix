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
    modules/git
    modules/gpg
  ];

  home.username = conf.user.name;
  home.homeDirectory = conf.user.home;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    quasselClient
  ];

  home.stateVersion = "22.05";
}
