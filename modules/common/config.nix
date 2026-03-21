{ lib, ... }:

with lib;
{
  options.my.user = {
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    fullname = mkOption { type = types.str; };
  };

  config.my.user = {
    name = mkDefault "audron";
    email = mkDefault "audron@cocaine.farm";
    fullname = mkDefault "Max Audron";
  };
}
