{
  config,
  lib,
  pkgs,
  user,
  catppuccin,
  machineName,
  ...
}:
let
  linux = pkgs.stdenv.isLinux;
in
{
  imports = [
    catppuccin.homeModules.catppuccin

    ./desktop
    ./games

    ./core
    ./editor
    ./music
    ./progs
    ./tools

    ../../machines/${machineName}/home.nix
  ];

  home.username = user.name;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.name}" else "/home/${user.name}";

  home.sessionVariables = {
    LEDGER_FILE = "${config.home.homeDirectory}/Documents/hledger.journal";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";

    firefox.force = true;
    cursors = {
      enable = linux;
      accent = "dark";
    };
  };

  home.packages =
    with pkgs;
    [
      nix-index
    ]
    ++ (
      if linux then
        [
          quasselClient

          discord
          unstable.teamspeak6-client

          hledger
          hledger-web
        ]
      else
        [ ]
    );

  programs.imv.enable = linux;
  programs.mpv.enable = true;
  programs.tmux.enable = true;
  programs.btop.enable = true;

  home.stateVersion = "25.05";
}
