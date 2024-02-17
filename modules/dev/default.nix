{ config, lib, pkgs, gtree, system, ... }:

with lib;
let
  cfg = config.home.dev;
  conf = import ../config { inherit lib; };
in {
  imports = [ ./kubernetes.nix ./terraform.nix ./golang.nix ./rust.nix ./3d_printing.nix ];

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
        file

        morph

        openssl

        nodejs

        # gtree.packages.${system}.default
      ] ++ (if conf.os.work then [
        bootstrap
        ansible-run
      ] else
        [ ]) ++ (if conf.os.type == "linux" then [
          linuxKernel.packages.linux_zen.perf
          blackmagic
          gcc-arm-embedded
        ] else
          [ ]);

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
