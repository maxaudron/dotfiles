{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ ncmpcpp ];

  services.mpd = {
    enable = true;
    package = pkgs.mpd.overrideAttrs (prev: {
      buildInputs = prev.buildInputs ++ [ pkgs.libnpupnp ];
      mesonFlags = prev.mesonFlags ++ [ "-Dupnp=npupnp" ];
    });

    dbFile = null;

    extraConfig = ''
      input {
        plugin "curl"
      }

      database {
        plugin "upnp"
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
