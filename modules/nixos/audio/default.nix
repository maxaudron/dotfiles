{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.audio;
in
{
  imports = [
    ./wireplumber
    ./filter-chain

    ./windows.nix
  ];

  options.my.audio = {
    enable = mkEnableOption "audio";

    autoConnect = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "Set up pipewire links on startup.";
      example = [
        {
          input = "a";
          output = "b";
          connect = { };
        }
      ];
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pipewire;
    };

    sampleSize = mkOption {
      type = types.int;
      default = 32;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      helvum
      pwvucontrol
      pulseaudio
    ];

    services.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      package = cfg.package;

      jack = {
        enable = false;
      };
      pulse = {
        enable = true;
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        enable = true;
      };

      extraConfig = {
        pipewire."91-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 32;
          };
        };

        pipewire-pulse."92-low-latency" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = { };
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = "32/48000";
            "pulse.default.req" = "32/48000";
            "pulse.max.req" = "32/48000";
            "pulse.min.quantum" = "32/48000";
            "pulse.max.quantum" = "32/48000";
          };
          "stream.properties" = {
            "node.latency" = "32/48000";
            "resample.quality" = 1;
          };
        };
      };
    };

    environment.variables =
      let
        makePluginPath =
          format:
          (makeSearchPath format [
            "$HOME/.nix-profile/lib"
            "/run/current-system/sw/lib"
            "/etc/profiles/per-user/$USER/lib"
          ])
          + ":$HOME/.${format}";
      in
      {
        DSSI_PATH = makePluginPath "dssi";
        LADSPA_PATH = makePluginPath "ladspa";
        LV2_PATH = makePluginPath "lv2";
        LXVST_PATH = makePluginPath "lxvst";
        VST_PATH = makePluginPath "vst";
        VST3_PATH = makePluginPath "vst3";
      };
  };
}
