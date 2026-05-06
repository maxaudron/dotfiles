{
  config,
  lib,
  pkgs,
  ...
}:

let
  kubernetes-helm-wrapped =
    with pkgs;
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
      ];
    });

  helmfile = pkgs.helmfile-wrapped.override {
    inherit (kubernetes-helm-wrapped) pluginsDir;
  };
in
{
  options.my.tools.kubernetes = {
    enable = lib.mkEnableOption "kubernetes";
  };

  config = lib.mkIf config.my.tools.kubernetes.enable {
    home.packages = with pkgs; [
      krew
      stern
      tanka
      kubectl
      helmfile
      kubernetes-helm-wrapped

      kube-capacity
      jsonnet-bundler
      jsonnet

      kubectl-ssh
      kubectl-netshoot

      konstraint
      kube-review
      argocd

      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      awscli2
      aws-adfs

      (callPackage ../../../pkgs/kubectx { })
    ];

    programs.fish.interactiveShellInit = ''
      set --global --export KUBECONFIG "$HOME/.kube/config:$(find ~/.kube/configs -type f | paste -sd ':' - )"
    '';

    home.shellAliases = {
      awslogin = "aws-adfs login --adfs-host=\"sso.mgt.de.clara.net\" --provider-id urn:amazon:webservices --no-session-cache --session-duration 36000 --profile ";
    };
  };
}
