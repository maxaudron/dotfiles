{
  pkgs,
  config,
  lib,
  system,
  ...
}:

with lib;

let
  conf = import ../config { inherit lib; };
in
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;

    extensions = [
      "html"
      "catppuccin"
      "toml"
      "nix"
      "sql"
      "make"
      "terraform"
      "scss"
      "graphql"
      "csv"
      "python"
    ];

    userKeymaps = [
      {
        "context" = "Editor";
        "bindings" = {
          "ctrl-h" = [
            "workspace::ActivatePaneInDirection"
            "Left"
          ];
          "ctrl-l" = [
            "workspace::ActivatePaneInDirection"
            "Right"
          ];
          "ctrl-k" = [
            "workspace::ActivatePaneInDirection"
            "Up"
          ];
          "ctrl-j" = [
            "workspace::ActivatePaneInDirection"
            "Down"
          ];
        };
      }
      {
        "context" = "VimControl && !menu";
        "bindings" = {
          "space space" = "file_finder::Toggle";
          "space t" = "terminal_panel::ToggleFocus";
        };
      }
      {
        "context" = "Dock";
        "bindings" = {
          "ctrl-h" = [
            "workspace::ActivatePaneInDirection"
            "Left"
          ];
          "ctrl-l" = [
            "workspace::ActivatePaneInDirection"
            "Right"
          ];
          "ctrl-k" = [
            "workspace::ActivatePaneInDirection"
            "Up"
          ];
          "ctrl-j" = [
            "workspace::ActivatePaneInDirection"
            "Down"
          ];
        };
      }
    ];

    userSettings = {
      "vim_mode" = true;
      "ui_font_size" = 16;
      "buffer_font_family" = "IBM Plex Mono";
      "buffer_font_size" = 16;
      "buffer_line_height" = "standard";
      "ui_font_family" = "IBM Plex Sans";
      "theme" = {
        "mode" = "system";
        "light" = "One Light";
        "dark" = "Catppuccin Mocha";
      };

      "use_system_path_prompts" = true;

      "gutter" = {
        "line_numbers" = false;
        "code_actions" = true;
        "runnables" = true;
        "folds" = true;
      };

      "soft_wrap" = "preferred_line_length";
      "preferred_line_length" = 110;

      "telemetry" = {
        "diagnostics" = false;
        "metrics" = false;
      };
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };

      assistant = {
        enabled = true;
        default_model = {
          provider = "openai";
          model = "codestral";
        };
      };

      language_models = {
        openai = {
          api_url = "https://ai.vapor.systems/v1";
          available_models = [
            {
              name = "gpt-4o-mini";
              display_name = "gpt-4o-mini";
              max_tokens = 128000;
            }
            {
              name = "gpt-4o";
              display_name = "gpt-4o";
              max_tokens = 128000;
            }
            {
              name = "mistral-nemo";
              display_name = "mistral-nemo";
              max_tokens = 128000;
            }
            {
              name = "mistral-large";
              display_name = "mistral-large";
              max_tokens = 128000;
            }
            {
              name = "codestral";
              display_name = "codestral";
              max_tokens = 256000;
            }
          ];
          version = "1";
        };
      };
    };
  };
}
