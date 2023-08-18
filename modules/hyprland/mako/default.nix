{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.mako pkgs.libnotify ];

  xdg.configFile."mako/config" = {
    source = ./mako.conf;
    onChange = ''
      ${pkgs.mako}/bin/makoctl reload
      ${pkgs.libnotify}/bin/notify-send -a "mako reloaded" -t 5000 "mako has been reloaded"
    '';
  };
}
