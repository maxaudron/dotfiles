{
  config,
  lib,
  pkgs,
  ...
}:

rec {
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

      paths = {
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "$artist/Singles/$title";
        comp = "Compilations/$album%aunique{}/$track $title";
        "albumtype:soundtrack" = "Soundtracks/$album/$track $title";
      };

      import = {
        copy = true;
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

  xdg.configFile."beets/config.yaml".source = lib.mkForce (
    pkgs.writeText "beets-config" (
      builtins.readFile ((pkgs.formats.yaml { }).generate "beets-config" programs.beets.settings)
      + ''
        replace:
            '[\\/]': _
            '^\.': _
            '[\x00-\x1f]': _
            '[<>"\?\*\|]': _
            ':': ""
            '\.$': _
            '\s+$': ""
            '^\s+': ""
            '^-': _
      ''
    )
  );
}
