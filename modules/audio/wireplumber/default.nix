{ config, lib, pkgs, ... }:

let
  cfg = config.audio;
in

with lib; {
  environment.etc = {
    wireplumber-main = {
      target = "wireplumber/main.lua.d/91-user-scripts.lua";
      source = ./91-user-scripts.lua;
    };
    wireplumber-scripts = {
      target = "wireplumber/scripts/auto-connect-ports.lua";
      text = ''
        ${readFile ./auto-connect-ports.lua}

        ${toString (map ({ input, output, connect }:
        ''
        auto_connect_ports {
          output = Constraint { "port.alias", "matches", "${input}" },
          input = Constraint { "port.alias", "matches", "${output}" },
          connect = {
            ${toString (attrValues (mapAttrs ( a: b: ''["${a}"] = "${b}",
            '') connect))}
          }
        }
        '')
        cfg.autoConnect)}
      '';
    };
  };
}
