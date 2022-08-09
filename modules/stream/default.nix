{ config, lib, pkgs, ... }:

let
  obsXwayland = pkgs.makeDesktopItem {
    name = "OBS Studio (X11)";
    desktopName = "OBS Studio (X11)";
    exec = "env -u WAYLAND_DISPLAY ${pkgs.obs-studio}/bin/obs";
    terminal = false;
    genericName = "Streaming/Recording Software";
    comment = "Free and Open Source Streaming/Recording Software";
    icon = "com.obsproject.Studio";
    type = "Application";
  };
in {
  home.packages = with pkgs; [ v4l-utils obsXwayland ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-midi
    ];
  };
}
