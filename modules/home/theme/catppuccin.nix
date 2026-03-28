{ lib, config, pkgs, catppuccin, ... }:

{
  imports = [ catppuccin.homeModules.catppuccin ];
  config =
    lib.mkIf (config.my.theme.style == "catppuccin") (
      lib.mkMerge [
        {
          catppuccin = {
            enable = true;
            flavor = "mocha";

            firefox.force = true;
            thunderbird.profile = "audron";
            cursors = {
              enable = pkgs.stdenv.isLinux;
              accent = "dark";
            };
          };
        }

        (lib.mkIf config.my.progs.mc.enable {
          xdg.dataFile."mc/skins/catppuccin.ini".source = "${
            fetchGit {
              url = "https://github.com/catppuccin/mc";
              rev = "f1c78f183764cd43e6dd4e325513ef5547a8f28f";
            }
          }/catppuccin.ini";

          xdg.configFile."mc/ini".text = lib.generators.toINI { } {
            "Midnight-Commander" = {
              skin = "catppuccin";
            };
          };
        })
      ]
    );
}
