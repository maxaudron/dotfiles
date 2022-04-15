{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in {
  config = lib.mkIf config.home.dev.rust {
    home.packages = with pkgs; [
      rust-bin.stable.latest.default
      unstable.rust-analyzer
    ];

    home.file.".cargo/config.toml".text = if pkgs.stdenv.isLinux then ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${unstable.clang}/bin/clang"
      rustflags = ["-Clink-arg=--ld-path=${unstable.mold}/bin/mold"]
    '' else "";
  };
}
