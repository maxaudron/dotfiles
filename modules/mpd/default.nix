{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ ncmpcpp ];

  services.mpd = {
    enable = true;
    dbFile = null;

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
}
