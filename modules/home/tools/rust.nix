{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.rust = {
    enable = lib.mkEnableOption "rust";
  };

  config = lib.mkIf config.my.tools.rust.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      # rust-analyzer

      cargo-outdated
      cargo-expand
      cargo-watch
      cargo-cross
      cargo-tarpaulin
      cargo-nextest
      #unstable.dioxus-cli
    ];

    xdg.configFile."rust-analyzer/rust-analyzer.toml".source =
      (pkgs.formats.toml { }).generate "rust-analyzer.toml"
        {
          diagnostics = {
            disabled = [
              "inactive-code"
            ];
          };
          cargo = {
            buildScripts = {
              enable = true;
            };
          };
          procMacro = {
            enable = true;
          };
        };

    home.file.".cargo/config.toml".text = ''
      [registries.crates-io]
      protocol = "sparse"
    ''
    + (
      if pkgs.stdenv.isLinux then
        ''

          [target.x86_64-unknown-linux-gnu]
          linker = "${pkgs.clang}/bin/clang"
          rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
        ''
      else
        ""
    );
  };
}
