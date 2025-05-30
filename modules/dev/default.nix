{
  config,
  lib,
  pkgs,
  gtree,
  system,
  ...
}:

with lib;
let
  cfg = config.home.dev;
  conf = import ../config { inherit lib; };
in
{
  imports = [
    ./kubernetes.nix
    ./terraform.nix
    ./golang.nix
    ./3d_printing.nix
    ./rust.nix
  ];

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
    home.packages =
      with pkgs;
      [
        gnumake
        file

        morph

        openssl

        nodejs

        nixd
       	nil
	clang-tools

        fd
        zstd
        gnutls
        binutils
        imagemagick
        editorconfig-core-c
        emacs-all-the-icons-fonts
        (ripgrep.override { withPCRE2 = true; })

        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US

        vale
        # rnix-lsp
        # python39Packages.pylsp-mypy
        nodePackages.typescript-language-server
        pyright

        nodePackages.prettier

        gtree.packages.${system}.default
      ]
      ++ (
        if conf.os.work then
          [
            bootstrap
            ansible-run
            ansible
          ]
        else
          [ ]
      )
      ++ (
        if conf.os.type == "linux" then
          [
            linuxKernel.packages.linux_zen.perf
            blackmagic
            gcc-arm-embedded
          ]
        else
          [ ]
      );

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };
}
