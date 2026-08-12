{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.tools.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf config.my.tools.printing.enable {
    home.packages = with pkgs; [
      unstable.prusa-slicer
    ];

    xdg.desktopEntries.buddy3d = {
      name = "Buddy3D Printer Camera";
      comment = "Camera feed for my 3d printer";
      icon = "mpv";
      type = "Application";
      exec = ''${pkgs.mpv}/bin/mpv --cache=no --profile=low-latency --osc=no --geometry=427x240 --title="buddy3d" rtsp://192.168.144.188/live'';
      terminal = false;
      categories = [
        "AudioVideo"
        "Video"
        "Player"
      ];
      mimeType = [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/x-msvideo"
        "audio/mpeg"
      ];
    };
  };
}
