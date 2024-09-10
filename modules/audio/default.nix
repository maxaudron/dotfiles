{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.audio;
in
{
  imports = [
    ./wireplumber
    ./filter-chain
  ];

  options = {
    audio = {
      autoConnect = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = "Set up pipewire links on startup.";
        example = [{
          input = "a";
          output = "b";
          connect = { };
        }];
      };

      package = mkOption {
        type = types.package;
        default = pkgs.pipewire;
      };

      sampleSize = mkOption {
        type = types.int;
        default = 128;
      };
    };
  };

  config = {
    security.pam.loginLimits = [
      { domain = "*"; item = "rtprio"; type = "hard"; value = "0"; }
      { domain = "*"; item = "rtprio"; type = "soft"; value = "0"; }
      { domain = "@audio"; item = "rtprio"; type = "hard"; value = "99"; }
      { domain = "@audio"; item = "rtprio"; type = "soft"; value = "20"; }
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@rtkit"; item = "rtprio"; type = "hard"; value = "99"; }
      { domain = "@rtkit"; item = "rtprio"; type = "soft"; value = "20"; }
      { domain = "@rtkit"; item = "memlock"; type = "-"; value = "unlimited"; }
    ];

    systemd.user.services = {
      scream = {
        wantedBy = [ "default.target" ];
        requires = [ "pipewire.service" "pipewire-pulse.socket" ];
        after = [ "pipewire-pulse.service" ];
        description = "Start the scream server to receive audio from windows";
        preStart = "${pkgs.bash} -c 'sleep 30'";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.scream}/bin/scream -o pulse -s windows -i enp5s0";
        };
      };
    };
    systemd.services = {
      rtkit-daemon = {
        serviceConfig = {
          ExecStart = [
            ""
            "-${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=99 --max-realtime-priority=95"
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      helvum
      pavucontrol
      pulseaudio
      scream

      lsp-plugins
    ];

    sound.enable = true;
    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      package = cfg.package;

      jack = { enable = true; };
      pulse = { enable = true; };
      alsa = { enable = true; };

      wireplumber = {
        enable = true;
      };

      extraConfig = {
        pipewire = {
          context.properties = {
            link.max-buffers = 64;
            log.level = 2;
            default.clock.rate = 48000;
            default.clock.quantum = cfg.sampleSize;
            default.clock.min-quantum = cfg.sampleSize;
            default.clock.max-quantum = cfg.sampleSize;
            core.daemon = true;
            core.name = "pipewire-0";
          };

          context.modules = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                nice.level = -15;
                rt.prio = 88;
                rt.time.soft = 200000;
                rt.time.hard = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
          ];
        };

        pipewire-pulse = {
          context.modules = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                nice.level = -15;
                rt.prio = 88;
                rt.time.soft = 200000;
                rt.time.hard = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                pulse.min.req = "${toString cfg.sampleSize}/48000";
                pulse.default.req = "${toString cfg.sampleSize}/48000";
                pulse.max.req = "${toString cfg.sampleSize}/48000";
                pulse.min.quantum = "${toString cfg.sampleSize}/48000";
                pulse.max.quantum = "${toString cfg.sampleSize}/48000";
                server.address = [ "unix:native" ];
              };
            }
          ];

          stream.properties = {
            node.latency = "${toString cfg.sampleSize}/48000";
            resample.quality = 1;
          };
        };
      };
    };

    environment.variables =
      let
        makePluginPath = format:
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
