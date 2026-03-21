{ ... }:

{
  my.audio = {
    enable = true;
    windows.enable = true;
    filter = {
      output = true;
      microphone = true;
    };

    autoConnect = [
      # System Output
      {
        input = "System Output:output_*";
        output = "EQ IE600 Oratory:*";
        connect = {
          "FL" = "FL";
          "FR" = "FR";
        };
      }
      {
        input = "System Output:output_*";
        output = "EQ Speaker:*";
        connect = {
          "FL" = "FL";
          "FR" = "FR";
        };
      }
      {
        input = "EQ IE600 Oratory:output_*";
        output = "FiiO K11 R2R:*";
        connect = {
          "FL" = "AUX0";
          "FR" = "AUX1";
        };
      }
      {
        input = "EQ IE600 Oratory:output_*";
        output = "UMC1820:playback_*";
        connect = {
          "FL" = "AUX2";
          "FR" = "AUX3";
        };
      }
      {
        input = "EQ Speaker:output_*";
        output = "UMC1820:playback_*";
        connect = {
          "FL" = "AUX0";
          "FR" = "AUX1";
        };
      }

      # Optical Audio Passthrough
      {
        input = "UMC1820:capture_*";
        output = "System Output:*";
        connect = {
          "AUX8" = "FL";
          "AUX9" = "FR";
        };
      }

      # Microphone
      {
        input = "UMC1820:capture_*";
        output = "Microphone:*";
        connect = {
          "AUX0" = "AUX0";
          "AUX1" = "AUX1";
        };
      }
    ];
  };
}
