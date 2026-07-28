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
              "ClovisLLM/glm5.1" = {
                name = "GLM 5.1";
              };
              "ClovisChat/Ornith-1.0-35B" = {
                name = "Ornith 1.0 35B";
              };
            };
          };
          clara = {
            npm = "@ai-sdk/openai-compatible";
            name = "clara";
            options = {
              baseURL = "https://public.llm.de.clara.net";
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
            };
          };
        };
        mcp = {
          # git-search = {
          #   type = "remote";
          #   url = "https://git-search.prod.cke.de.clara.net/mcp";
          #   enabled = true;
          # };
          git-search-dev = {
            type = "remote";
            url = "https://git-search.dev.cke.de.clara.net/mcp";
            enabled = true;
          };
        };
      };
    };
  };
}
