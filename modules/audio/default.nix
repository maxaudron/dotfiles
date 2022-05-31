{ config, lib, pkgs, ... }:

with lib;

let
  sampleSize = 128;

  cfg = config.audio;

  pkgPipewire = (pkgs.pipewire.overrideAttrs (old: {
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "pipewire";
          repo = "pipewire";
          rev = "0c8cd4ab52557681df70e24df9072e2df7c7d6ff";
          sha256 = "sha256-zBcM/rTsnKfANrswAPMFaLr+6w4YEsS2c9x7rvW6UL4=";
        };
        mesonFlags = old.mesonFlags ++ [ "-Dbluez5-codec-lc3plus=disabled" ];
      }));

in {
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
        default = pkgPipewire;
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
          ExecStart = map ({ input, output }:
            ''${pkgs.pipewire}/bin/pw-link "${input}" "${output}"'')
            cfg.defaultLinks;
          ExecStop = map ({ input, output }:
            ''${pkgs.pipewire}/bin/pw-link -d "${input}" "${output}"'')
            cfg.defaultLinks;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      helvum
      pavucontrol
      pulseaudio
    ];

    sound.enable = true;
    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      package = cfg.package;

      jack = { enable = true; };
      pulse = { enable = true; };

      media-session.enable = false;
      wireplumber = {
        enable = true;
      };

      config = {
        pipewire = {
          "context.properties" = {
            "link.max-buffers" = 64;
            "log.level" = 2;
            "default.clock.rate" = 48000;
            "default.clock.quantum" = sampleSize;
            "default.clock.min-quantum" = sampleSize;
            "default.clock.max-quantum" = sampleSize;
            "core.daemon" = true;
            "core.name" = "pipewire-0";
          };
          "context.modules" = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
            { name = "libpipewire-module-protocol-native"; }
            { name = "libpipewire-module-profiler"; }
            { name = "libpipewire-module-metadata"; }
            { name = "libpipewire-module-spa-device-factory"; }
            { name = "libpipewire-module-spa-node-factory"; }
            { name = "libpipewire-module-client-node"; }
            { name = "libpipewire-module-client-device"; }
            {
              name = "libpipewire-module-portal";
              flags = [ "ifexists" "nofail" ];
            }
            {
              name = "libpipewire-module-access";
              args = { };
            }
            { name = "libpipewire-module-adapter"; }
            { name = "libpipewire-module-link-factory"; }
            { name = "libpipewire-module-session-manager"; }
          ];
        };

        pipewire-pulse = {
          "context.properties" = { "log.level" = 2; };
          "context.modules" = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
            { name = "libpipewire-module-protocol-native"; }
            { name = "libpipewire-module-client-node"; }
            { name = "libpipewire-module-adapter"; }
            { name = "libpipewire-module-metadata"; }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                "pulse.min.req" = "${toString sampleSize}/48000";
                "pulse.default.req" = "${toString sampleSize}/48000";
                "pulse.max.req" = "${toString sampleSize}/48000";
                "pulse.min.quantum" = "${toString sampleSize}/48000";
                "pulse.max.quantum" = "${toString sampleSize}/48000";
                "server.address" = [ "unix:native" ];
              };
            }
          ];
          "stream.properties" = {
            "node.latency" = "${toString sampleSize}/48000";
            "resample.quality" = 1;
          };
        };
      };
    };
  };
}
