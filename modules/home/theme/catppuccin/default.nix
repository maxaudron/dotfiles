{
  lib,
  config,
  pkgs,
  catppuccin,
  ...
}:

let
  cat = config.catppuccin;
in
{
  imports = [ catppuccin.homeModules.catppuccin ];
  config = lib.mkIf (config.my.theme.style == "catppuccin") (
    lib.mkMerge [
      {
        catppuccin = {
          enable = true;
          autoEnable = true;
          flavor = "mocha";
          accent = "peach";

          firefox.force = true;
          thunderbird.profile = "audron";
          cursors = {
            enable = pkgs.stdenv.isLinux;
            accent = "dark";
          };
        };

        programs.noctalia.settings.colorSchemes.predefinedScheme = "Catppuccin";

        programs.fish.interactiveShellInit = ''
          set --global hydro_color_pwd 'cba6f7'

          if set -q SSH_CONNECTION
            set -l palette \
                #89b4fa \
                #74c7ec \
                #89dceb \
                #94e2d5 \
                #a6e3a1 \
                #f9e2af \
                #fab387 \
                #eba0ac \
                #f38ba8 \
                #f38ba8 \
                #f5c2e7 \
                #babbf1 \
                #a6d189 \
                #ef9f76 \
                #ea999c \
                #ca9ee6

            set -l hash_val (echo (hostname) | md5sum | cut -c 1-8)
            set -l index (math "0x$hash_val % "(count $palette))

            set -g fish_color_host $palette[(math $index + 1)]
            set --global hydro_color_pwd $fish_color_host
          end

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

      (lib.mkIf config.programs.meli.enable (
        let
          theme = "catppuccin-${cat.flavor}-${cat.accent}";
        in
        {
          programs.meli.settings.terminal.theme = theme;
          xdg.configFile."meli/themes/${theme}.toml".source = "${
            fetchGit {
              url = "https://github.com/maxaudron/catppuccin-meli";
              rev = "0e97a3f5a60a9213e45491d234c2c6edeff54652";
            }
          }/dist/${theme}.toml";
        }
      ))

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
