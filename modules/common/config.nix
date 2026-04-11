{ lib, ... }:

with lib;
{
  options.my.user = {
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    fullname = mkOption { type = types.str; };
    pubkey = mkOption { type = types.str; };
  };

  config.my.user = {
    name = mkDefault "audron";
    email = mkDefault "me@audron.dev";
    fullname = mkDefault "Max Audron";
    pubkey = mkDefault "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBnsvdLYjsNTKeBf7pKdE7YEwzPmw+0NxE49IHVkFvnCAAAACnNzaDphdWRyb24= ssh:audron";
  };
}
