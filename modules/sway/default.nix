{ pkgs, ... }:

{
  imports = [
    ../../modules/common/userland.nix
    ../rofi
    # ./waybar

    ./keybinds.nix
    ./input.nix
    ./theme.nix

    # (./specifics + "/${sysconfig.networking.hostName}.nix")
    (./specifics/liduur.nix)
  ];

  # services.gammastep = {
  #   enable = true;
  #   provider = "manual";
  #   latitude = 50.0;
  #   longitude = 8.6;
  # };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    systemdIntegration = true;

    config = {
      modifier = "Mod4";
      focus = {
        newWindow = "smart";
        followMouse = "yes";
      };
    };

    xwayland = true;
  };
}
