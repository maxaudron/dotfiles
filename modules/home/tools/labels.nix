{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.my.tools.labels = {
    enable = lib.mkEnableOption "labels";
  };

  config = lib.mkIf config.my.tools.labels.enable {
    home.packages = [ pkgs.brother-ql ];
    home.sessionVariables = {
      BROTHER_QL_PRINTER = "tcp://192.168.144.174";
      BROTHER_QL_MODEL = "PT-P750W";
    };
  };
}
