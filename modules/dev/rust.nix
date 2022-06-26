{ config, lib, pkgs, system, inputs, ... }:

let
  rust = with inputs.fenix.packages.${system};
    combine [
      stable.defaultToolchain
      targets.x86_64-unknown-linux-musl.stable.rust-std
      targets.thumbv6m-none-eabi.stable.rust-std

      rust-analyzer
    ];
in {
  config = lib.mkIf config.home.dev.rust {
    home.packages = with pkgs; [
      rust

      cargo-outdated
    ];

    home.file.".cargo/config.toml".text = if pkgs.stdenv.isLinux then ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang}/bin/clang"
      rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    '' else "";
  };
}
