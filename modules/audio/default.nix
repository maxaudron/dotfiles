{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  sampleSize = 128;

in {
  disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];

  imports = [
    <nixos-unstable/nixos/modules/services/desktops/pipewire/wireplumber.nix>
    <nixos-unstable/nixos/modules/services/desktops/pipewire/pipewire.nix>

    ./filter-chain
  ];

  environment.systemPackages = with pkgs; [
    helvum
    pavucontrol
    pulseaudio
    rnnoise-plugin
    lsp-plugins
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    package = unstable.pipewire;

    jack = { enable = true; };
    pulse = { enable = true; };

    media-session.enable = false;
    wireplumber = {
      enable = true;
      package = unstable.wireplumber;
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
}
