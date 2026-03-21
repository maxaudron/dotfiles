{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.go = {
    enable = lib.mkEnableOption "go";
  };

  config = lib.mkIf config.my.tools.go.enable {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
    ];
  };
}
