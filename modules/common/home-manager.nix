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
    users."${config.my.user.name}" = self.homeManagerModules.default;

    extraSpecialArgs = inputs // {
      inherit builtins system machineName;
      user = config.my.user;
    };
  };
}
