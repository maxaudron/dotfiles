{
  lib,
  config,
  pkgs,
  catppuccin,
  ...
}:

{
  imports = [ catppuccin.homeModules.catppuccin ];
  config = lib.mkIf (config.my.theme.style == "catppuccin") (
    lib.mkMerge [
      {
        catppuccin = {
          enable = true;
          flavor = "mocha";
          accent = "peach";

          firefox.force = true;
          thunderbird.profile = "audron";
          cursors = {
            enable = pkgs.stdenv.isLinux;
            accent = "dark";
          };
        };
        
        programs.noctalia-shell.settings.colorSchemes.predefinedScheme = "Catppuccin";

        programs.fish.interactiveShellInit = ''
          set --global hydro_color_pwd 'cba6f7'
          set --global hydro_color_prompt 'cba6f7'
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
                    theme = {
                      colors = {
                        frame = lib.mkForce {
                          "b" = 46;
                          "g" = 30;
                          "r" = 30;
                        };
                        frame_inactive = lib.mkForce {
                          "b" = 46;
                          "g" = 30;
                          "r" = 30;
                        };
                      };
                    };
                  };
                };
              };
            };
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
      (import ./hyprland.nix { inherit lib config; })
    ]
  );
}
