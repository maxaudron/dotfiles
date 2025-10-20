{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    dbFile = null;
    musicDirectory = "/share/music/";

    extraConfig = ''
      input {
        plugin "curl"
      }

      # resampler {
      #   plugin "soxr"
      #   quality "very high"
      # }

      audio_output {
        type "pipewire"
        name "MPD"
      }
    '';
  };

  services.mpdris2 = {
    enable = true;
  };

  programs.ncmpcpp = {
    enable = true;
  };
}
