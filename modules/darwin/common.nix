{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
  };
}
