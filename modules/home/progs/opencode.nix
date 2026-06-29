{ config, lib, ... }:

{
  options.my.progs.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf config.my.progs.opencode.enable {
    programs.opencode = {
      enable = true;
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
            };
          };
          local = {
            npm = "@ai-sdk/openai-compatible";
            name = "Local";
            options = {
              baseURL = "http://10.10.0.11:8888/v1";
            };
            models = {
              "unsloth/Qwen3.6-27B-MTP-GGUF" = {
                name = "Qwen 3.6 27B MTP";
              };
            };
          };
        };
      };
    };
  };
}
