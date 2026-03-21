{
  config,
  lib,
  pkgs,
  ...
}:

let
  json = pkgs.formats.json { };

  microphone_data = import ./microphone.nix;
  system-out_data = import ./system-out.nix;

  pluginsEnv = "LV2_PATH=${pkgs.lsp-plugins}/lib/lv2";

  microphone = json.generate "microphone.conf" (microphone_data pkgs);
  system-out = json.generate "system-out.conf" (system-out_data pkgs);

  cfg = config.my.audio;
in
{
  options.my.audio.filter = {
    microphone = lib.mkEnableOption "microphone";
    output = lib.mkEnableOption "output";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      pipewire-filter-system-out = lib.mkIf cfg.filter.output {
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

      pipewire-filter-microphone = lib.mkIf cfg.filter.microphone {
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
  };
}
