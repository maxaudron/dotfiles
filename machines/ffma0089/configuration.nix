{
  config,
  pkgs,
  secrets,
  ...
}:

{
  imports = [ "${secrets}/work.nix" ];

  users.users."${config.my.user.name}" = {
    name = config.my.user.name;
    home = "/Users/${config.my.user.name}";
    uid = 502;
    shell = pkgs.fish;
  };
  users.knownUsers = [ config.my.user.name ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [ qemu ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;

  nix.settings.trusted-users = [ "@staff" ];
 
  system.primaryUser = config.my.user.name;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
