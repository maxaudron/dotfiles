{ config, lib, pkgs, ... }:

let
  json = pkgs.formats.json { };

  microphone_data = import ./microphone.nix;
  system-out_data = import ./system-out.nix;

  pluginsEnv = "LV2_PATH=${pkgs.lsp-plugins}/lib/lv2";

  microphone = json.generate "microphone.conf" (microphone_data pkgs);
  system-out = json.generate "system-out.conf" (system-out_data pkgs);

  cfg = config.audio;
in {
  environment.etc."pipewire/filter-chain/microphone.conf" = {
    source = microphone;
  };

  environment.etc."pipewire/filter-chain/system-out.conf" = {
    source = system-out;
  };

  systemd.user.services = {
    pipewire-filter-system-out = {
      wantedBy = [ "pipewire.service" ];
      requires = [ "pipewire.service" ];
      after = [ "pipewire.service" ];
      description = "Start the system output filter chain";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/pipewire -c ${system-out}";
        Environment = pluginsEnv;
      };
    };
    pipewire-filter-microphone = {
      wantedBy = [ "pipewire.service" ];
      requires = [ "pipewire.service" ];
      after = [ "pipewire.service" ];
      description = "Start the microphone filter chain";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/pipewire -c ${microphone}";
        Environment = pluginsEnv;
      };
    };
  };
}
