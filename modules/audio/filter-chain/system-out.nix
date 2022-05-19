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

            {
              type = "builtin";
              label = "copy";
              name = "outFL";
            }
            {
              type = "builtin";
              label = "copy";
              name = "outFR";
            }
          ];

          links = [
            {
              output = "copyFL:Out";
              input = "convFL:In";
            }
            {
              output = "copyFR:Out";
              input = "convFR:In";
            }

            {
              output = "copyFL:Out";
              input = "outFL:In";
            }
            {
              output = "copyFR:Out";
              input = "outFR:In";
            }
          ];
          inputs = [ "copyFL:In" "copyFR:In" ];
          outputs = [ "convFL:Out" "convFR:Out" "outFL:Out" "outFR:Out" ];
        };
        "capture.props" = {
          "node.name" = "effect_input.system-output";
          "media.role" = "Processing";
          "media.class" = "Audio/Sink";
          "audio.channels" = 2;
          "audio.position" = [ "FL" "FR" ];
        };
        "playback.props" = {
          "node.name" = "effect_output.system-output";
          "node.passive" = true;
          "node.target" =
            "alsa_output.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-output-0";
          "audio.channels" = 4;
          "audio.position" = [ "AUX0" "AUX1" "AUX2" "AUX3" ];
        };
      };
    }
  ];
}
