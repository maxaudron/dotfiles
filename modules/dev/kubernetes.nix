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
      kube-capacity
      jsonnet-bundler
      jsonnet

      kubectl-ssh
      kubectl-netshoot

      open-policy-agent
      konstraint
      kube-review
      argocd

      (callPackage ../../pkgs/kubectx {})
    ];
  };
}
