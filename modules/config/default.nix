{ lib, ... }:

{
  user = {
    name = "audron";
    home = "/home/audron";
    email = "audron@cocaine.farm";
    fullname = "Max Audron";
  };

  os = {
    type = "linux";
    work = false;
  };
} // (if lib.pathExists ../../config.toml then (lib.importTOML ../../config.toml) else {})
