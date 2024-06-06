{ config, pkgs, lib, builtins, ... }:

with lib;

let conf = import ../../modules/config { inherit lib; };
in {
  imports = [
    ../../modules/doom-emacs
    ../../modules/alacritty
    ../../modules/latex
    ../../modules/shell
    ../../modules/git
    ../../modules/gpg
    ../../modules/dev
    ../../modules/ssh
  ];

  home.username = conf.user.name;
  home.homeDirectory = lib.mkForce conf.user.home;

  programs.home-manager.enable = true;

  programs.gpg.scdaemonSettings = { disable-ccid = true; };

  home.packages = with pkgs; [ pass nix-index wireguard-tools wireguard-go helix ];

  home = { sessionPath = [ "/opt/podman/bin" ]; };

  programs.browserpass.enable = true;

  home.stateVersion = "22.05";
}
