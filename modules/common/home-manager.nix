{
  self,
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
    users."${config.my.user.name}" = self.homeManagerModules.default // {
      my.user = config.my.user;
    };

    extraSpecialArgs = inputs // {
      inherit builtins system machineName;
    };
  };
}
