{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.home.dev.golang {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
    ];
  };
}
