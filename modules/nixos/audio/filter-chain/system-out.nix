{ config, ... }:

let
  cfg = config.my.audio;
in
{
  # System Output Sink
  #
  # One stereo pair input, two pairs output
  # Pair 1 (AUX0 AUX1) has speaker EQ applied via convoler
  # Pair 2 (AUX2 AUX3) is copy of input

  "context.properties" = {
    "log.level" = 0;

    "default.clock.rate" = 48000;
    "default.clock.quantum" = cfg.sampleSize;
    "default.clock.min-quantum" = cfg.sampleSize;
    "default.clock.max-quantum" = cfg.sampleSize;
  };

  "context.spa-libs" = {
    "audio.convert.*" = "audioconvert/libspa-audioconvert";
    "support.*" = "support/libspa-support";
  };

  "context.modules" = [
    {
      name = "libpipewire-module-rtkit";
      args = {
        "nice.level" = -15;
        "rt.prio" = 88;
      };
      flags = [
        "ifexists"
        "nofail"
      ];
    }
    { name = "libpipewire-module-protocol-native"; }
    { name = "libpipewire-module-client-node"; }
    { name = "libpipewire-module-adapter"; }

    {
      name = "libpipewire-module-filter-chain";
      args = {
        "node.description" = "System Output";
        "media.name" = "System Output";
        "filter.graph" = {
          nodes = [
            {
              type = "builtin";
              label = "copy";
              name = "copyFL";
            }
            {
              type = "builtin";
              label = "copy";
              name = "copyFR";
            }
          ];

          inputs = [
            "copyFL:In"
            "copyFR:In"
          ];
          outputs = [
            "copyFL:Out"
            "copyFR:Out"
          ];
        };
        "capture.props" = {
          "node.name" = "System Output";
          "media.role" = "Processing";
          "media.class" = "Audio/Sink";
          "audio.channels" = 2;
          "audio.position" = [
            "FL"
            "FR"
          ];
        };
        "playback.props" = {
          "node.name" = "System Output";
          "node.autoconnect" = false;
          "audio.channels" = 2;
          "audio.position" = [
            "FL"
            "FR"
          ];
        };
      };
    }

    {
      name = "libpipewire-module-parametric-equalizer";
      args = {
        "equalizer.filepath" = ./ir_responses/ie600_oratory.txt;
        "equalizer.description" = "EQ IE600 Oratory";
        "audio.channels" = 2;
        "audio.position" = [
          "FL"
          "FR"
        ];
        "capture.props" = {
          "node.name" = "EQ IE600 Oratory";
          "node.autoconnect" = false;
        };
        "playback.props" = {
          "node.name" = "EQ IE600 Oratory";
          "node.autoconnect" = false;
          "audio.channels" = 2;
          "audio.position" = [
            "FL"
            "FR"
          ];
        };
      };
    }

    {
      name = "libpipewire-module-filter-chain";
      args = {
        "node.description" = "EQ Speaker";
        "media.name" = "EQ Speaker";
        "filter.graph" = {
          nodes = [
            {
              type = "builtin";
              label = "convolver";
              name = "convFL";
              config = {
                filename = "${./ir_responses/speaker_eq.wav}";
                channel = 0;
              };
            }
            {
              type = "builtin";
              label = "convolver";
              name = "convFR";
              config = {
                filename = "${./ir_responses/speaker_eq.wav}";
                channel = 1;
              };
            }
          ];

          inputs = [
            "convFL:In"
            "convFR:In"
          ];
          outputs = [
            "convFL:Out"
            "convFR:Out"
          ];
        };
        "capture.props" = {
          "node.name" = "EQ Speaker";
          "node.autoconnect" = false;
          "media.role" = "Processing";
          "media.class" = "Audio/Sink";
          "audio.channels" = 2;
          "audio.position" = [
            "FL"
            "FR"
          ];
        };
        "playback.props" = {
          "node.name" = "EQ Speaker";
          "node.autoconnect" = false;
          "node.passive" = true;
          "audio.channels" = 2;
          "audio.position" = [
            "FL"
            "FR"
          ];
        };
      };
    }
  ];
}
