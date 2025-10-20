{
  config,
  pkgs,
  lib,
  ...
}:

let
  conf = import ../../modules/config { inherit lib; };
in
{
  imports = [ 
    ../../modules/common 
    ../../modules/home-manager
  ];

  users.users."${conf.user.name}" = {
    name = conf.user.name;
    home = conf.user.home;
    uid = 502;
    shell = pkgs.fish;
  };
  users.knownUsers = [ conf.user.name ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [ qemu ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;

  nix.settings.trusted-users = [ "@staff" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
