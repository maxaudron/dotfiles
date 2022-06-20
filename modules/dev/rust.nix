{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" ];
    targets = [ "x86_64-unknown-linux-gnu" "x86_64-unknown-linux-musl" "thumbv6m-none-eabi" ];
  };
in {
  config = lib.mkIf config.home.dev.rust {
    home.packages = with pkgs; [
      rust

      unstable.rust-analyzer
      cargo-outdated
    ];

    home.file.".cargo/config.toml".text = if pkgs.stdenv.isLinux then ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang}/bin/clang"
      rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    '' else "";
  };
}
