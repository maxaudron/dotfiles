{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.home.dev.kubernetes {
    home.packages = with pkgs; [
      krew
      stern
      tanka
      kubectl
      helmfile
      kubernetes-helm
      jsonnet-bundler

      (callPackage ../../pkgs/kubectx {})
    ];
  };
}
