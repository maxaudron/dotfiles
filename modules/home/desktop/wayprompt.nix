{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.desktop.wayprompt = {
    enable = lib.mkEnableOption "wayprompt";
  };

  config = lib.mkIf config.my.desktop.wayprompt.enable {
    xdg.configFile = {
      "wayprompt/config.ini".text = lib.generators.toINI { } {
        general = {
          border = "2;";
          corner-radius = "15;";
        };

        colours = rec {
          background = "0x1e1e2e;";
          border = "0xcba6f7;";
          text = "0xcdd6f4;";
          error-text = "0xf38ba8;";
          pin-background = "0x181825;";
          pin-border = border;
          pin-square = text;
          ok-button = "0xa6e3a1;";
          ok-button-border = ok-button;
          ok-button-text = "0x313244;";
          not-ok-button = "0xf38ba8;";
          not-ok-button-border = not-ok-button;
          not-ok-button-text = ok-button-text;
          cancel-button = "0xfab387;";
          cancel-button-border = cancel-button;
          cancel-button-text = ok-button-text;
        };
      };
    };

    services.gpg-agent.pinentry = {
      package = pkgs.wayprompt;
      program = "pinentry-wayprompt";
    };
  };
}
