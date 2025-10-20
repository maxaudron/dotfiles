{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.mpd = {
    enable = true;
    dbFile = null;
    musicDirectory = "/mnt/media/Music/";

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

  programs.beets = {
    enable = true;
    package = (
      pkgs.unstable.beets.override {
        pluginOverrides = {
          musicbrainz.enable = true;
        };
      }
    );

    settings = {
      directory = "/mnt/media/Music";
      library = "/mnt/media/music.db";

      import = {
        copy = "yes";
      };

      plugins = [
        "musicbrainz"
        "fish"
      ];

      musicbrainz = {
        host = "localhost:5000";
        ratelimit = 100;
        https = false;
        genres = true;
      };
    };
  };
}
