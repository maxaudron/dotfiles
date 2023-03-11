{ config, lib, pkgs, system, fenix, ... }:

let
  rust = with fenix.packages.${system};
    combine [
      stable.defaultToolchain
      (stable.withComponents [
        "rust-src"
      ])
      targets.x86_64-unknown-linux-musl.stable.rust-std
      targets.thumbv6m-none-eabi.stable.rust-std

      rust-analyzer
    ];
in {
  config = lib.mkIf config.home.dev.rust {
    home.packages = with pkgs; [
      rust

      cargo-outdated
      cargo-expand
      cargo-watch
    ];

    home.file.".cargo/config.toml".text = ''
      [registries.crates-io]
      protocol = "sparse"
    '' +
    (if pkgs.stdenv.isLinux then ''

      [target.x86_64-unknown-linux-gnu]
      linker = "${pkgs.clang}/bin/clang"
      rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    '' else
      "");
  };
}
