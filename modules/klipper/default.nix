{ config, lib, pkgs, ... }:

{
  users = {
    users.klipper = {
        isSystemUser = true;
        group = "klipper";
    };
    groups.klipper = {};
  };


  services.klipper = {
    enable = true;
    mutableConfig = true;
    mutableConfigFolder = "/var/lib/moonraker/config";
    configFile = ./printer.cfg;
    user = "klipper";
    group = "klipper";
  };

  services.moonraker = {
    enable = true;
    allowSystemControl = true;

    group = "klipper";
    settings = {
      authorization = {
        cors_domains = [
          "*"
        ];
        trusted_clients = [
          "192.168.144.0/24"
          "127.0.0.0/24"
        ];
      };
    };
  };

  services.mainsail = {
    enable = true;
    nginx =
    {
      serverAliases = [ "fluidd.${config.networking.domain}" ];
      extraConfig = ''
        client_max_body_size 100M;
      '';
    };
  };
}
