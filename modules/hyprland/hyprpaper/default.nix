{ pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    package = pkgs.unstable.hyprpaper;
    settings =
      let
        wallpaper = "~/.dotfiles/misc/wallpaper/evening-sky.png";
      in
      {
        preload = wallpaper;
        wallpaper = [
          {
            monitor = "DP-1";
            path = wallpaper;
          }
          {
            monitor = "DP-2";
            path = wallpaper;
          }
        ];
      };
  };
}
