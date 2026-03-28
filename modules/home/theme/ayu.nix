{ lib, config, pkgs, ... }:

{
  config =
    lib.mkIf (config.my.theme.style == "ayu") (
      lib.mkMerge [
        {
          programs.ghostty.settings.theme = "Ayu";
          programs.noctalia-shell.settings.coloSchemes.predefinedScheme = "Ayu";
          programs.btop.settings.color_theme = "ayu";
        }

        (lib.mkIf config.my.progs.mc.enable {
          xdg.dataFile."mc/skins/catppuccin.ini".source = "${
            fetchGit {
              url = "https://github.com/egorkonovalov/ayu-dark-mc";
              rev = "18e9b7204f67cdc9d67573ca9f31599b1ecba006";
            }
          }/ayu-dark.ini";

          xdg.configFile."mc/ini".text = lib.generators.toINI { } {
            "Midnight-Commander" = {
              skin = "ayu-dark";
            };
          };
        })
      ]
    );
}
