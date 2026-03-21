{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.work = {
    enable = lib.mkEnableOption "work";
  };

  config = lib.mkIf config.my.tools.work.enable {
    my.tools.kubernetes.enable = true;
    home.packages = with pkgs; [
      bootstrap
      ansible-run
      ansible
      terraform

      (azure-cli.override { withImmutableConfig = false; })
    ];
  };
}
