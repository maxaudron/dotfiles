{ config, lib, ... }:

{
  options.my.music.mpd = {
    enable = lib.mkEnableOption "mpd";
  };

  config = lib.mkIf config.my.music.mpd.enable {
    my.music.rmpc.enable = true;

    services.mpd = {
      enable = true;
      dbFile = null;
      musicDirectory = "/mnt/media/Music/";

      network.listenAddress = "0.0.0.0";

      extraConfig = ''
        resampler {
          plugin "soxr"
          quality "very high"
        }

        audio_output {
          type "pipewire"
          name "MPD"

          replay_gain_handler "mixer"
        }

        replaygain "album"
      '';
    };

    services.mpdscribble = {
      enable = true;
      endpoints = {
        "last.fm" = {
          username = "maxaudron";
          passwordFile = "/etc/mpd/lastfm.key";
        };
      };
    };

    services.mpdris2 = {
      enable = true;
    };
  };
}
