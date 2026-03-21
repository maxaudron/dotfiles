{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.aerospace = {
    enable = true;
    # launchd.enable = true;
    settings = {};
  };
}
