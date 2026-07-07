{
  lib,
  pkgs,
  ...
}:

with lib;
{
  imports = [
    ./3d_printing.nix
    ./kubernetes.nix
    ./embedded.nix
    ./golang.nix
    ./labels.nix
    ./latex.nix
    ./rust.nix
    ./wine.nix
    ./work.nix
    ./podman
  ];

  config = {
    home.packages = with pkgs; [
      gnumake
      file

      # network
      curl
      openssl
      gnutls
      whois
      wget
      dig

      fd
      zstd
      binutils
      imagemagick
      (ripgrep.override { withPCRE2 = true; })

      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US

      htop
      btop

      # gtree.packages.${system}.default

      llm-usage

      tokei
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
