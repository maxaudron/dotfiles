{
  config,
  lib,
  machineName,
  ...
}:

{
  imports = [
    ./keybinds.nix
    ./input.nix
    ./theme.nix

    # (./specifics + "/${sysconfig.networking.hostName}.nix")
    (./specifics/${machineName}.nix)
  ];

  options.my.desktop.sway = {
    enable = lib.mkEnableOption "sway";
  };

  config = lib.mkIf config.my.desktop.sway.enable {
    my.desktop.rofi.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures = {
        gtk = true;
        base = true;
      };

      systemd.enable = true;

      config = {
        modifier = "Mod4";
        focus = {
          newWindow = "smart";
          followMouse = "yes";
        };
      };

      xwayland = true;
    };
  };
}
