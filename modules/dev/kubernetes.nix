{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.home.dev.kubernetes {
    home.packages = with pkgs; [ krew tanka kubectl kubectx helmfile kubernetes-helm ];
  };
}
