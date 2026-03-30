{ config, lib, ... }:

with lib;

let
  cfg = config.my.theme;
in
{
  imports = [
    ./ayu
    ./catppuccin.nix
  ];

  options.my.theme = {
    enable = mkEnableOption "";
    style = mkOption {
      type = types.enum [
        "catppuccin"
        "ayu"
      ];
    };
  };

  config = {
    my.theme = {
      enable = lib.mkDefault true;
      style = lib.mkDefault "catppuccin";
    };
  };
}
