{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.my.progs.kanidm = {
    enable = lib.mkEnableOption "kanidm";
  };

  config = lib.mkIf config.my.progs.kanidm.enable {
    home.packages = [ pkgs.kanidm_1_10 ];

    home.sessionVariables = {
      KANIDM_URL = "https://id.vapor.systems";
      KANIDM_NAME = "audron";
    };
  };
}
