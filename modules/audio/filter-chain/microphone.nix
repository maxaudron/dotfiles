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
              type = "lv2";
              name = "comp";
              # plugin =
              #   "${pkgs.lsp-plugins}/lib/ladspa/lsp-plugins-ladspa.so";
              # label = "http://lsp-plug.in/plugins/lv2/compressor_mono";
              plugin = "http://lsp-plug.in/plugins/lv2/compressor_mono";
              control = {
                "Input gain (G)" = 1.0;
                "Output gain (G)" = 1.0;
                "Pause graph analysis" = false;
                "Clear graph analysis" = false;
                "Sidechain type" = 0;
                "Sidechain mode" = 1;
                "Sidechain lookahead (ms)" = 0.0;
                "Sidechain listen" = false;
                "Sidechain reactivity (ms)" = 10.0;
                "Sidechain preamp (G)" = 1.0;
                "High-pass filter mode" = 0;
                "High-pass filter frequency (Hz)" = 10.0;
                "Low-pass filter mode" = 0;
                "Low-pass filter frequency (Hz)" = 20000.0;
                "Compression mode" = 0;
                "Attack threshold (G)" = 5.020606e-2;
                "Attack time (ms)" = 2.0;
                "Release threshold (G)" = 0.0;
                "Release time (ms)" = 500.0;
                "Ratio" = 100.0;
                "Knee (G)" = 0.50329852;
                "Boost threshold (G)" = 2.51190009e-4;
                "Makeup gain (G)" = 1.0;
                "Dry gain (G)" = 0.0;
                "Wet gain (G)" = 1.0;
                "Sidechain level visibility" = false;
                "Envelope level visibility" = false;
                "Gain reduction visibility" = false;
                "Input level visibility" = false;
                "Output level visibility" = false;
              };
            }
            {
              type = "builtin";
              label = "copy";
              name = "copy";
            }
            {
              type = "builtin";
              label = "copy";
              name = "L";
            }
            {
              type = "builtin";
              label = "copy";
              name = "R";
            }
          ];
          links = [
            {
              output = "comp:out";
              input = "copy:In";
            }
            {
              output = "copy:Out";
              input = "L:In";
            }
            {
              output = "copy:Out";
              input = "R:In";
            }
          ];
          outputs = [ "L:Out" "R:Out" ];
        };
        "capture.props" = {
          "node.name" = "effect_input.microphone";
          "node.target" = "effect_output.rnnoise";
          "node.passive" = true;
          "audio.channels" = 1;
          "audio.position" = [ "AUX0" ];
        };
        "playback.props" = {
          "media.class" = "Audio/Source";
          "node.name" = "effect_output.microphone";
          "node.passive" = true;
          "audio.channels" = 1;
          "audio.position" = [ "AUX0" "AUX1" ];
        };
      };
    }
  ];
}
