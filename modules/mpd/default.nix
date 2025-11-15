{
  config,
  lib,
  pkgs,
  system,
  beets-rockbox,
  ...
}:

let
  conf = import ../config { inherit lib; };
in
rec {
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

  programs.rmpc = {
    enable = true;
    package = pkgs.unstable.rmpc;
  };

  xdg.configFile = {
    "rmpc/config.ron".source =
      config.lib.file.mkOutOfStoreSymlink "${conf.user.home}/.dotfiles/modules/mpd/rmpc/config.ron";
    "rmpc/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${conf.user.home}/.dotfiles/modules/mpd/rmpc/themes";
  };

  programs.beets = {
    enable = true;
    package =
      (pkgs.python313Packages.beets.overrideAttrs (
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
                (pkgs.python313Packages.beets-alternatives.overrideAttrs (
                  final: prev: rec {
                    pyproject = true;
                    version = "0.13.4-6fd4dff";
                    src = pkgs.fetchFromGitHub {
                      repo = "beets-alternatives";
                      owner = "geigerzaehler";
                      rev = "6fd4dffdd8216fb45dea015209787dc8df3440f6";
                      hash = "sha256-flJbcQ1z54ADU0QIPral9waKshtbIF44vpBDgnxcMUw=";
                    };

                    patches = [
                      ./alternatives_copy_art.patch
                    ];

                    buildInputs = [ pkgs.python313Packages.hatchling ];
                    build-system = [ pkgs.python313Packages.hatchling ];

                    disabledTestPaths = [
                      "dev/get_release_notes.py"
                    ];
                  }
                ))
              ];
            };
            rockbox = {
              enable = true;
              propagatedBuildInputs = [
                (beets-rockbox.packages."${system}".default)
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
        host = "musicbrainz.vapor.systems";
        ratelimit = 150;
        https = true;
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
