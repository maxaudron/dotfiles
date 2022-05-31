{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.home.dev;
  conf = import ../config { inherit lib; };
in {
  imports = [ ./kubernetes.nix ./terraform.nix ./golang.nix ./rust.nix ];

  options.home.dev = {
    kubernetes = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Kubernetes related config and packages";
    };

    terraform = mkOption {
      type = types.bool;
      default = true;
      description = "Enable terraform related config and packages";
    };

    golang = mkOption {
      type = types.bool;
      default = true;
      description = "Enable golang development related config and packages";
    };

    rust = mkOption {
      type = types.bool;
      default = true;
      description = "Enable rust development related config and packages";
    };
  };

  config = {
    home.packages = with pkgs;
      [
        gnumake

        morph

        gcc
        glibc
        openssl

        linuxKernel.packages.linux_zen.perf
      ] ++ (if conf.os.work then [
        (callPackage ../../pkgs/bootstrap { })
        (callPackage ../../pkgs/ansible-run { })
      ] else
        [ ]);

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
