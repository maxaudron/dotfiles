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

  home.sessionVariables = {
    LEDGER_FILE = "${config.home.homeDirectory}/Documents/hledger.journal";
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
  programs.mpv.enable = linux;
  programs.tmux.enable = true;
  programs.btop.enable = true;

  home.stateVersion = "25.05";
}
