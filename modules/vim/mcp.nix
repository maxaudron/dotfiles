{
  config,
  pkgs,
  lib,
  system,
  mcp-hub,
  ...
}:

# http://localhost:24282/dashboard/

{
  home.packages = with pkgs; [
    serena
    mcp-hub.packages."${system}".default
  ];

  xdg.configFile."mcphub/servers.json".text = lib.generators.toJSON {} {
    mcpServers = {
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
}
