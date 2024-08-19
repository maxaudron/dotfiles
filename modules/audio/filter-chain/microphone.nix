{ pkgs, ... }:

 {
  # System Output Sink
  #
  # One stereo pair input, two pairs output
  # Pair 1 (AUX0 AUX1) has speaker EQ applied via convoler
  # Pair 2 (AUX2 AUX3) is copy of input
  #
  "context.properties" = {
    "log.level" = 0;

    "default.clock.rate" = 48000;
    "default.clock.quantum" = 256;
  };

  "context.spa-libs" = {
    "audio.convert.*" = "audioconvert/libspa-audioconvert";
    "support.*" = "support/libspa-support";
  };

  "context.modules" = [
    {
      name = "libpipewire-module-rtkit";
      args = {
        #nice.level   = -11
        #rt.prio      = 88
        #rt.time.soft = 200000
        #rt.time.hard = 200000
      };
      flags = [ "ifexists" "nofail" ];
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
                type  = "builtin";
                name  = "mixer";
                label = "mixer";
                control = { "Gain 1" = 0.5; "Gain 2" = 0.5; };
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
          inputs  = [ "mixer:In 1" "mixer:In 2" ];
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
          outputs = [ "aux0:Out" "aux1:Out" ];
        };
        "capture.props" = {
          "node.name" = "effect_input.microphone";
          # "node.target" = "effect_output.microphone";
          "node.passive" = true;
          "audio.channels" = 2;
          "audio.position" = [ "AUX0" "AUX1" ];
        };
        "playback.props" = {
          "media.class" = "Audio/Source";
          "node.name" = "effect_output.microphone";
          "node.passive" = true;
          "audio.channels" = 2;
          "audio.position" = [ "AUX0" "AUX1" ];
        };
      };
    }
  ];
}
