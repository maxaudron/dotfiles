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
    package =
      (pkgs.beets.overrideAttrs (
        final: prev: {
          patches = [ ./single-artist.patch ];
          disabledTests = prev.disabledTests ++ [
            "test_parse_recording_artist_multi"
            "test_track_artist_overrides_recording_artist_multi"
            "test_two_artists"
          ];
        }
      )).override
        {
          pluginOverrides = {
            alternatives = {
              enable = true;
              propagatedBuildInputs = [
                (pkgs.beetsPackages.alternatives.overrideAttrs (
                  final: prev: rec {
                    version = "0.13.4";

                    src = pkgs.fetchFromGitHub {
                      repo = "beets-alternatives";
                      owner = "geigerzaehler";
                      tag = "v${version}";
                      hash = "sha256-jGHRoBBXqJq0r/Gbp7gkuaEFPVMGE6cqQRi84AHTXxQ=";
                    };

                    patches = [
                      ./alternatives_copy_art.patch
                      ./alternatives_fix_tests.patch
                    ];
                    disabledTestPaths = [
                      "dev/get_release_notes.py"
                    ];
                  }
                ))
              ];
            };
            edit.enable = true;
            embedart.enable = true;
            fetchart.enable = true;
            info.enable = true;
            lyrics.enable = true;
            musicbrainz.enable = true;
            mpdupdate.enable = true;
            convert.enable = true;
          };
        };

    settings = {
      plugins = [
        "alternatives"
        "edit"
        "embedart"
        "fetchart"
        "info"
        "lyrics"
        # "musicbrainz"
        "mpdupdate"
        "convert"
        "fish"
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
        };
      };

      convert = {
        quiet = true;
        dest = "/mnt/media/Music.opus";
        never_convert_lossy_files = true;

        embed = false;
        copy_album_art = true;
        album_art_maxwidth = 1200;

        format = "opus";
        formats = {
          opus = {
            command =
              let
                opusTools = pkgs.opusTools.overrideAttrs (
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
              ''
                ${opusTools}/bin/opusenc --music --bitrate 128 --comp 10 $source $dest
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
      };

      lyrics = {
        auto = false;
        sources = [ "lrclib" ];
        synced = true;
        print = true;
      };

      musicbrainz = {
        enabled = true;
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
