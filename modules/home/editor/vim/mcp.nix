{
  config,
  pkgs,
  lib,
  system,
  mcp-hub,
  ...
}:

{
  config = lib.mkIf config.my.editor.vim.enable {
    home.packages = with pkgs; [
      serena
      mcp-hub.packages."${system}".default
    ];

    xdg.configFile."mcphub/servers.json".text = lib.generators.toJSON { } {
      mcpServers = {
        git-search = {
          url = "http://127.0.0.1:8080/mcp";
        };
        serena = {
          args = [
            "--transport=stdio"
            "--project=\${workspaceFolder}"
            "--context=ide-assistant"
          ];
          command = "${pkgs.serena}/bin/serena-mcp-server";
          custom_instructions = {
            disabled = false;
          };
          cwd = "\${workspaceFolder}";
          env = { };
        };
      };
    };
  };
}
