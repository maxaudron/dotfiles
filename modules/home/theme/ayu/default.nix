{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.my.theme.style == "ayu") (
    lib.mkMerge [
      {
        programs.ghostty.settings.theme = "Ayu";
        programs.noctalia-shell.settings.coloSchemes.predefinedScheme = "Ayu";
        programs.btop.settings.color_theme = "ayu";

        programs.fish.interactiveShellInit = ''
          set --global hydro_color_pwd 'E6B450'
          set --global hydro_color_prompt 'E6B450'
        '';

        textfox.config.border.color = "#313244";
        programs.firefox = {
          profiles = {
            "audron" = {
              extensions = {
                force = true;
                settings."FirefoxColor@mozilla.com" = {
                  settings = {
                    firstRunDone = true;
                    theme = lib.importJSON ./firefox/manifest.json;
                  };
                };
              };
            };
          };
        };

        programs.neovim.plugins = [{
          plugin = pkgs.vimPlugins.neovim-ayu;
          config = ''
            lua << EOF
              require("catppuccin").setup({
                mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
                terminal = true, -- Set to `false` to let terminal manage its own colors.
                overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
              })
              vim.api.nvim_command("colorscheme ayu")
            EOF
          '';
        }];
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
