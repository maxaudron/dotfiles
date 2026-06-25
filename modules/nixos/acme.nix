{
  config,
  lib,
  secrets,
  ...
}:

{
  options.my.acme = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf config.my.acme.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "hostmaster@vapor.systems";
        dnsProvider = "pdns";
        environmentFile = config.secrets.pdns.dest;
      };
    };

    secrets = {
      pdns = {
        source = "${secrets}/pdns.env";
        dest = "/etc/secrets/pdns.env";
      };
    };
  };
}
