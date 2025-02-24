{ config, lib, pkgs, system, fenix, ... }:

{
  config = lib.mkIf config.home.dev.rust {
    home.packages = with pkgs; [
      rustc
      cargo
      rust-analyzer

      unstable.cargo-outdated
      cargo-expand
      cargo-watch
      cargo-cross
      cargo-tarpaulin
      #unstable.dioxus-cli
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
