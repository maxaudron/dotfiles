{ config, lib, pkgs, ... }:

let
  weechat-matrix = pkgs.callPackage ./weechat-matrix-rs.nix {};
  weechat = pkgs.unstable.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with pkgs.unstable.weechatScripts; [
        colorize_nicks
        multiline
        weechat-autosort
      ];
    };
  };
in
{


# [dependencies]
# clap = "2.34.0"
# chrono = "0.4.22"
# dashmap = "5.4.0"
# indoc = "1.0.7"
# url = "2.3.1"
# serde_json = "1.0.85"
# strum = "0.20.0"
# strum_macros = "0.20.1"
# syntect = "5.0.0"
# tokio = { version = "1.21.1", features = [ "rt-multi-thread", "sync" ] }
# tracing = "0.1.36"
# tracing-subscriber = { version = "0.3.15", features = ["env-filter"] }
# uuid = { version = "1.1.2", features = ["v4"] }
# unicode-segmentation = "1.10.0"

  home.packages = [ weechat ];
}
