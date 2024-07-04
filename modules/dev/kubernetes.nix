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

      google-cloud-sdk
      awscli2
      aws-adfs

      (callPackage ../../pkgs/kubectx {})
    ];

    home.shellAliases = {
      awslogin = "aws-adfs login --adfs-host=\"sso.mgt.de.clara.net\" --provider-id urn:amazon:webservices --no-session-cache --session-duration 36000 --profile ";
    };
  };
}
