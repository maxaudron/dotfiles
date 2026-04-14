{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.my.progs.hledger = {
    enable = lib.mkEnableOption "hledger";
  };

  config = lib.mkIf config.my.progs.hledger.enable {
    home.packages = [ pkgs.hledger ];

    home.sessionVariables = {
      LEDGER_FILE = "${config.home.homeDirectory}/Documents/hledger.journal";
    };
  };
}
