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
          convert.enable = true;
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
        "albumtypes:soundtrack" = "Soundtracks/$album/$track $title";
      };

      import = {
        move = true;
      };

      convert = {
        embed = true;
        quiet = true;
        auto_keep = true;
        dest = "/mnt/media/Music.opus";
        never_convert_lossy_files = true;

        format = "opus";
        formats = {
          opus = {
            command = ''
              ${pkgs.opusTools}/bin/opusenc --music --bitrate 128 --comp 10 $source $dest
            '';
            extension = "opus";
          };
        };
      };

      plugins = [
        "musicbrainz"
        "convert"
        "fish"
      ];

      musicbrainz = {
        host = "musicbrainz.vapor.systems";
        ratelimit = 150;
        https = true;
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
