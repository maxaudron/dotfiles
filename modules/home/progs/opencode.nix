{
  system,
  config,
  lib,
  pkgs,
  omp,
  ...
}:

{
  imports = [
    omp.homeManagerModules.default
  ];

  options.my.progs.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf config.my.progs.opencode.enable {
    programs.omp = {
      enable = true;
      package = omp.packages.${system}.default.override { withAppleFm = false; };
    };

    home.sessionVariables = {
      PI_CONFIG_DIR = ".config/omp";
      OLLAMA_BASE_URL = "http://192.168.144.11:11434";
    };

    xdg.configFile."omp/agent/mcp.json".source = (
      (pkgs.formats.json { }).generate "mcp.json" {
        mcpServers = {
          git-search = {
            type = "http";
            url = "https://git-search.prod.cke.de.clara.net/mcp";
          };
        };
      }
    );

    xdg.configFile."omp/agent/models.yml".source = (
      (pkgs.formats.yaml { }).generate "models.yml" {
        providers = {
          sglang = {
            baseUrl = "http://10.10.0.7:8000/v1";
            api = "openai-responses";
            auth = "none";
            discovery = {
              type = "openai-models-list";
            };
          };
          clara = {
            baseUrl = "https://ai-llm.prod.cke.de.clara.net/v1";
            apiKey = "!pass show work/llm";
            api = "openai-responses";
            discovery = {
              type = "litellm";
            };
          };
          clara-old = {
            baseUrl = "https://public.llm.de.clara.net/v1";
            apiKey = "!pass show work/litellm_claude | head -n1";
            api = "openai-responses";
            discovery = {
              type = "litellm";
            };
          };
          clovis = {
            baseUrl = "https://llm-gateway.clovis-ai.fr/v1";
            apiKey = "!pass show work/clovis";
            api = "openai-responses";
            discovery = {
              type = "litellm";
            };
          };
        };
      }
    );

    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      settings = {
        provider = {
          sglang = {
            npm = "@ai-sdk/openai-compatible";
            name = "SGLang @ vllm-max";
            options = {
              baseURL = "http://10.10.0.7:8000/v1";
            };
            models = {
              "orcarouter/Qwen3.8-27B-Uncensored-FP8" = {
                name = "Qwen3.8 27B FP8";
              };
            };
          };
          clovis = {
            npm = "@ai-sdk/openai-compatible";
            name = "Clovis";
            options = {
              baseURL = "https://llm-gateway.clovis-ai.fr/v1";
            };
            models = {
              "ClovisLLM" = {
                name = "GLM 5.2";
              };
              "ClovisChat" = {
                name = "Qwen3.8 Flash Next (Chat)";
              };
              "ClovisChat/Qwen3.8-Flash-Next" = {
                name = "Qwen3.8 Flash Next";
              };
            };
          };
          clara = {
            npm = "@ai-sdk/openai-compatible";
            name = "clara";
            options = {
              baseURL = "https://ai-llm.prod.cke.de.clara.net";
            };
            models = {
              "claude-opus-4.8" = { };
              "claude-opus-4.7" = { };
              "claude-opus-4.6" = { };
              "claude-opus-4.5" = { };
              "claude-sonnet-5" = { };
              "claude-sonnet-4.6" = { };
              "claude-sonnet-4.7" = { };
              "claude-haiku-4.5" = { };
              "gpt-5.6-lua" = { };
              "gpt-5.6-terra" = { };
              "gpt-5.6-sol" = { };
            };
          };
        };
        mcp = {
          litellm-dev = {
            type = "remote";
            url = "https://ai-llm.dev.cke.de.clara.net/mcp";
            enabled = true;
            headers = {
              Authorization = "Bearer {env:LITELLM_VIRTUAL_KEY}";
            };
          };
          llm-cloudatlas = {
            type = "remote";
            url = "https://ai-llm.dev.cke.de.clara.net/CloudAtlas_MCP/mcp";
            enabled = true;
          };
          cloudatlas = {
            type = "remote";
            url = "https://cloudatlas-mcp.dev.cke.de.clara.net/";
            enabled = true;
          };
          git-search = {
            type = "remote";
            url = "https://git-search.prod.cke.de.clara.net/mcp";
            enabled = true;
          };
          git-search-dev = {
            type = "remote";
            url = "https://git-search.dev.cke.de.clara.net/mcp";
            enabled = false;
          };
        };
      };
    };
  };
}
