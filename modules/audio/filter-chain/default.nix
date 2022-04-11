{ config, lib, pkgs, ... }:

let
  json = pkgs.formats.json { };

  microphone_data = import ./microphone.nix;
  system-out_data = import ./system-out.nix;

  microphone = json.generate "microphone.conf" (microphone_data pkgs);
  system-out = json.generate "system-out.conf" (system-out_data pkgs);
in {
  environment.etc."pipewire/filter-chain/microphone.conf" = {
    source = microphone;
  };

  environment.etc."pipewire/filter-chain/system-out.conf" = {
    source = system-out;
  };

  systemd.user.services = {
    # pipewire-filter-system-out = {
    #   wantedBy = [ "pipewire.service" ];
    #   requires = [ "pipewire.service" ];
    #   description = "Start the system output filter chain";
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.pipewire}/bin/pipewire -c ${system-out}";
    #   };
    # };
    pipewire-filter-microphone = {
      wantedBy = [ "pipewire.service" ];
      requires = [ "pipewire.service" ];
      after = [ "pipewire.service" ];
      description = "Start the microphone filter chain";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.pipewire}/bin/pipewire -c ${microphone}";
      };
    };
  };
}
