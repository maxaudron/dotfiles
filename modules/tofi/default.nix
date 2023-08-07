{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.tofi ];

  xdg.configFile."tofi/config" = {
    source = ./tofi.conf;
  };
}
