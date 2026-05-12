{
  config,
  pkgs,
  machineName,
  ...
}:
let
  linux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./theme
    ./desktop
    ./games

    ./core
    ./editor
    ./music
    ./progs
    ./tools

    ../../machines/${machineName}/home.nix
    ../common/config.nix
  ];

  home.username = config.my.user.name;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${config.my.user.name}" else "/home/${config.my.user.name}";

  home.packages = with pkgs; [
    nix-index
    nix-diff
    home-manager
  ];

  programs.imv.enable = linux;
  programs.mpv.enable = linux;
  programs.btop.enable = true;

  home.stateVersion = "25.05";
}
