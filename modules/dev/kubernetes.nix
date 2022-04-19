{ config, lib, pkgs, ... }:

let

in {
  config = lib.mkIf config.home.dev.kubernetes {
    home.packages = with pkgs; [
      krew
      tanka
      kubectl
      helmfile
      kubernetes-helm

      (callPackage ../../pkgs/kubectx {})
    ];
  };
}
