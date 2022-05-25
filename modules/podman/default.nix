{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.podman ];

  xdg = {
    enable = true;
    configFile = {
      "containers/containers.conf".text = ''
        [network]
        cni_plugin_dirs = [ "${pkgs.cni-plugins}/bin" ]
      '';
    };
  };
}
