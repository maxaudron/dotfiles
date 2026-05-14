{ config, ... }:

let
  cfg = config.my.audio;
in
{
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
        "node.description" = "Microphone";
        "media.name" = "Microphone";
        "filter.graph" = {
          nodes = [
            {
              type = "builtin";
              name = "mixer";
              label = "mixer";
              control = {
                "Gain 1" = 1;
                "Gain 2" = 1;
              };
            }
            {
              type = "builtin";
              label = "copy";
              name = "aux0";
            }
            {
              type = "builtin";
              label = "copy";
              name = "aux1";
            }
          ];
          inputs = [
            "mixer:In 1"
            "mixer:In 2"
          ];
          links = [
            {
              input = "aux0:In";
              output = "mixer:Out";
            }
            {
              input = "aux1:In";
              output = "mixer:Out";
            }
          ];
          outputs = [
            "aux0:Out"
            "aux1:Out"
          ];
        };
        "capture.props" = {
          "node.name" = "effect_input.microphone";
          # "node.target" = "effect_output.microphone";
          "node.passive" = true;
          "audio.channels" = 2;
          "audio.position" = [
            "AUX0"
            "AUX1"
          ];
        };
        "playback.props" = {
          "media.class" = "Audio/Source";
          "node.name" = "effect_output.microphone";
          "node.passive" = true;
          "audio.channels" = 2;
          "audio.position" = [
            "AUX0"
            "AUX1"
          ];
        };
      };
    }
  ];
}
