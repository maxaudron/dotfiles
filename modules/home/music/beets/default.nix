{
  config,
  lib,
  pkgs,
  system,
  beets-rockbox,
  ...
}:

let
  opusTools = pkgs.opus-tools.overrideAttrs (
    final: prev: {
      version = "2025-03-19";
      src = pkgs.fetchFromGitHub {
        owner = "xiph";
        repo = "opus-tools";
        rev = "bb045db2b479504702bf1f570476e2c3f0ceb678";
        hash = "sha256-duY1dFG3XDql5+dEy3pRIo/MtMz/mgjkwQhbMKEuI20=";
      };

      nativeBuildInputs = with pkgs; [
        pkg-config
        autoreconfHook
      ];
    }
  );
in
{
  options.my.music.beets = {
    enable = lib.mkEnableOption "beets";
  };

  config = lib.mkIf config.my.music.beets.enable {
    home.packages = [
      opusTools
      pkgs.id3v2
    ];

    programs.beets = {
      enable = true;
      package =
        (pkgs.unstable.python313Packages.beets.overrideAttrs (
          final: prev: {
            patches = [ ./0001-only-populate-artist-fields-with-single-artist.patch ];
            disabledTests = prev.disabledTests ++ [
              "test_parse_recording_artist_multi"
              "test_track_artist_overrides_recording_artist_multi"
              "test_track_overrides_recording"
              "test_two_artists"
            ];
          }
        )).override
          {
            pluginOverrides = {
              alternatives = {
                enable = true;
                propagatedBuildInputs = [ pkgs.unstable.python313Packages.beets-alternatives ];
              };
              rockbox = {
                enable = true;
                propagatedBuildInputs = [
                  # (pkgs.unstable.python313Packages.callPackage "${beets-rockbox}/nix/package.nix" {})
                ];
              };
              edit.enable = true;
              embedart.enable = true;
              fetchart.enable = true;
              info.enable = true;
              lastgenre.enable = true;
              lyrics.enable = true;
              musicbrainz.enable = true;
              mpdupdate.enable = true;
              convert.enable = true;
              replaygain.enable = true;
              permissions.enable = true;
            };
          };

      settings = {
        plugins = [
          "alternatives"
          "convert"
          "edit"
          "embedart"
          "fetchart"
          "fish"
          "info"
          "lastgenre"
          "lyrics"
          "musicbrainz"
          "mpdupdate"
          "permissions"
          "replaygain"
          "rockbox"
          "zero"
        ];

        directory = "/mnt/media/Music";
        library = "/mnt/media/music.db";

        paths = {
          default = "$albumartist/$album%aunique{}/$track $title";
          singleton = "$artist/Singles/$title";
          comp = "Compilations/$album%aunique{}/$track $title";
          "albumtypes:soundtrack" = "Soundtracks/$album/$track $title";
        };

        import = {
          write = true;
          move = true;
        };

        alternatives = {
          opus = {
            directory = "/mnt/media/Music.opus";
            formats = "opus mp3";

            album_art_embed = false;
            album_art_copy = true;
            album_art_format = "JPEG";
            album_art_maxwidth = 1200;
            album_art_deinterlace = true;
          };

          ipod = {
            directory = "/mnt/ipod/Music";
            formats = "opus mp3";

            album_art_embed = false;
            album_art_copy = true;
            album_art_format = "JPEG";
            album_art_maxwidth = 400;
            album_art_deinterlace = true;
          };
        };

        convert = {
          quiet = true;
          dest = "/mnt/media/Music.opus";
          never_convert_lossy_files = true;
          threads = 8;

          embed = false;
          copy_album_art = true;
          album_art_maxwidth = 1200;

          format = "opus";
          formats = {
            opus = {
              command = ''
                ${opusTools}/bin/opusenc --music --bitrate 160 --vbr --comp 10 $source $dest
              '';
              extension = "opus";
            };
          };
        };

        embedart = {
          auto = false;
          ifempty = false;
          maxwidth = 1200;
          quality = 75;
        };

        fetchart = {
          auto = true;

          sources = [
            "filesystem"
            "itunes"
            "coverart: releasegroup"
          ];
          store_source = true;
          high_resolution = true;
        };

        lastgenre = {
          auto = true;
          force = true;
          keep_existing = false;

          source = "track";
          canonical = true;
          prefer_specific = true;
          count = 1;
          whitelist = true;
          title_case = false;
        };

        lyrics = {
          auto = false;
          sources = [ "lrclib" ];
          synced = true;
          print = true;
        };

        musicbrainz = {
          enabled = true;
          # host = "musicbrainz.vapor.systems";
          # ratelimit = 150;
          # https = true;
          genres = true;
        };

        replaygain = {
          auto = true;
          backend = "ffmpeg";

          targetlevel = 84;
          r128_targetlevel = 84;
          r128 = "Opus FLAC";
          peak = "true";
        };

        rockbox = {
          db = "/mnt/ipod/.rockbox";
          rockbox = "/mnt/ipod/.rockbox";
          music = "/<HDD0>/Music";

          formats = [
            "opus"
            "mp3"
          ];
        };

        permissions = {
          file = "644";
          dir = "755";
        };

        zero = {
          auto = true;
          update_database = true;
          omit_single_disc = true;
          fields = lib.strings.concatStringsSep " " [
            "rg_album_gain"
            "rg_album_peak"
            "rg_track_gain"
            "rg_track_peak"
            "images"
          ];
        };
      };
    };

    xdg.configFile."beets/config.yaml".source = lib.mkForce (
      pkgs.writeText "beets-config" (
        builtins.readFile ((pkgs.formats.yaml { }).generate "beets-config" config.programs.beets.settings)
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
  };
}
