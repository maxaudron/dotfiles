{
  config,
  pkgs,
  lib,
  ...
}:
# http://localhost:24282/dashboard/

{
  systemd.user.services.serena = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Serena MCP Server";
      After = [ "default.target" ];
    };

    Service = {
      ExecStart = "${pkgs.serena}/bin/serena-mcp-server";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

