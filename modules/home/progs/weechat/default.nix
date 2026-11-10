{
  config,
  lib,
  pkgs,
  ...
}:

let
  # weechat-matrix = pkgs.callPackage ./weechat-matrix-rs.nix { };
  weechat = pkgs.unstable.weechat.override {
    configure =
      { availablePlugins, ... }:
      {
        scripts = with pkgs.unstable.weechatScripts; [
          colorize_nicks
          multiline
          weechat-autosort
        ];
        plugins = builtins.attrValues (builtins.removeAttrs availablePlugins [ "php" ]);
      };
  };
in
{
  options.my.progs.weechat = {
    enable = lib.mkEnableOption "weechat";
  };

  config = lib.mkIf config.my.progs.weechat.enable {
    home.packages = [ weechat ];

    home.xdg.configFiles = {
      "weechat/"
    }
  };
}
