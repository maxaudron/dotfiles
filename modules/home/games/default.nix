{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:

let
  factorio = pkgs.master.factorio-space-age.override (
    lib.importTOML ("${secrets}" + "/factorio.toml")
  );
in
{
  options.my.games.enable = lib.mkEnableOption "games";

  config = lib.mkIf config.my.games.enable {
    home.packages = [
      factorio
      pkgs.starsector
      pkgs.prismlauncher
    ];
  };
}
