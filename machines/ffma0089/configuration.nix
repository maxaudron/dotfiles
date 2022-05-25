{ config, pkgs, lib, ... }:

let conf = import ../../modules/config { inherit lib; };
in {
  imports = [ <home-manager/nix-darwin> ../../modules/common ];

  users.users."${conf.user.name}" = {
    name = conf.user.name;
    home = conf.user.home;
    uid = 502;
  };
  users.knownUsers = [ conf.user.name ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.users."${conf.user.name}" = import ./home.nix;

  programs.zsh.enable = true;

  home-manager.extraSpecialArgs = { inherit builtins; };

  environment.systemPackages = with pkgs; [ qemu podman ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages =
  #   [ pkgs.go
  #     pkgs.go-md2man
  #     pkgs.vim
  #     pkgs.exa
  #     pkgs.mpv
  #     pkgs.fzf
  #     pkgs.qemu
  #     pkgs.htop
  #     pkgs.inxi
  #     pkgs.stow
  #     pkgs.pass
  #     pkgs.gnupg
  #     pkgs.yabai
  #     pkgs.gvproxy
  #     pkgs.emacsUnstable
  #     # pkgs.pulseaudio
  #   ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
