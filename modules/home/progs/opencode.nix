{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.progs.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf config.my.progs.opencode.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      settings = {
        provider = {
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
