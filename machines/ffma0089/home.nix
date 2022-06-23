{ config, pkgs, lib, builtins, ... }:

with lib;

let
  conf = import ../../modules/config { inherit lib; };
in {
  imports = [
    ../../modules/podman/machine.nix
    ../../modules/doom-emacs
    ../../modules/alacritty
    ../../modules/shell
    ../../modules/git
    ../../modules/gpg
    ../../modules/dev
    ../../modules/ssh
  ];

  podman.machine = {
    memory = 2048;
    cpus = 4;
    diskSize = 100;
  };

  home.username = conf.user.name;
  home.homeDirectory = lib.mkForce conf.user.home;

  programs.home-manager.enable = true;

  programs.gpg.scdaemonSettings = { disable-ccid = true; };

  home.packages = with pkgs; [ pass ];

  home.stateVersion = "22.05";
}
