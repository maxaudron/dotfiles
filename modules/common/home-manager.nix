{
  self,
  lib,
  config,
  inputs,
  system,
  machineName,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${config.my.user.name}" = {
      imports = [ self.homeModules.default ];
      my.user = lib.mkForce config.my.user;
    };

    extraSpecialArgs = inputs // {
      inherit builtins system machineName;
    };
  };
}
