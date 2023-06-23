{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.audio;
in
{
  imports = [
    ./filter-chain
  ];

  options = {
    audio = {
      defaultLinks = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = "Set up pipewire links on startup.";
        example = [{
          input = "a";
          output = "b";
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

    systemd.user.services = {
      pipewire-setup-links = {
        wantedBy = [ "pipewire.service" "wireplumber.service" ];
        bindsTo = [ "pipewire.service" "wireplumber.service" ];
        after = [ "pipewire.service" "wireplumber.service" ];
        description = "Setup default pipewire links";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStartPre = "/run/current-system/sw/bin/sleep 2";
          ExecStart = map
            ({ input, output }:
              ''${pkgs.pipewire}/bin/pw-link "${input}" "${output}"'')
            cfg.defaultLinks;
          ExecStop = map
            ({ input, output }:
              ''${pkgs.pipewire}/bin/pw-link -d "${input}" "${output}"'')
            cfg.defaultLinks;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      unstable.helvum
      pavucontrol
      pulseaudio

      sunvox
      vcv-rack
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
    };

    environment.etc =
      let
        json = pkgs.formats.json { };
      in
      {
        "pipewire/pipewire.d/10-settings.conf".source = json.generate "10-settings.conf" {
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

        "pipewire/pipewire-pulse.conf.d/10-settings.conf".source = json.generate "10-settings.conf" {
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
}
