{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    package = pkgs.unstable.hyprpaper;
    settings =
      let
        wallpaper = "~/.dotfiles/wallpaper/evening-sky.png";
      in
      {
        preload = wallpaper;
        wallpaper = [
          "DP-1,${wallpaper}"
          "DP-2,${wallpaper}"
        ];
      };
  };
}
