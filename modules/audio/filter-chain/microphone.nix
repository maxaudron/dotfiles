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
            # {
            #   type = "builtin";
            #   label = "copy";
            #   name = "copy";
            # }
            # {
            #   type = "builtin";
            #   label = "copy";
            #   name = "L";
            # }
            # {
            #   type = "builtin";
            #   label = "copy";
            #   name = "R";
            # }
            {
              type = "lv2";
              name = "comp";
              # plugin =
              #   "${pkgs.lsp-plugins}/lib/ladspa/lsp-plugins-ladspa.so";
              # label = "http://lsp-plug.in/plugins/ladspa/compressor_mono";
              plugin = "http://lsp-plug.in/plugins/lv2/compressor_stereo";
              control = {
                "cm" = 2;
                "al" = 0.024150;
              };
            }
          ];
          # links = [
            # {
            #   output = "copy:Out";
            #   input = "L:In";
            # }
            # {
            #   output = "copy:Out";
            #   input = "R:In";
            # }
            # {
            #   output = "L:Out";
            #   input = "comp:in_l";
            # }
            # {
            #   output = "R:Out";
            #   input = "comp:in_r";
            # }
          # ];
          # outputs = [ "comp:out_l" "comp:out_r" ];
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
