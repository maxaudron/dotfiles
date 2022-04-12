{ config, lib, pkgs, ... }:

let
  pkgs = import <nixpkgs> { overlays = [ (import <rust-overlay>) ]; };
  unstable = import <nixos-unstable> { };
in {
  config = lib.mkIf config.home.dev.rust {
    nixpkgs.overlays = [
      (import (builtins.fetchTarball
        "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];

    home.packages = with pkgs; [
      rust-bin.stable.latest.default
      unstable.rust-analyzer
    ];

    home.file.".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${unstable.clang}/bin/clang"
      rustflags = ["-Clink-arg=--ld-path=${unstable.mold}/bin/mold"]
    '';
  };
}
