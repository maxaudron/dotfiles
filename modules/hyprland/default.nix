{ config, lib, pkgs, hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
  ];

  # home.packages = with pkgs; [
  #   wl-clipboard
  #   alacritty
  #   waybar
  #   seatd

  #   gtk-engine-murrine
  #   gtk_engines
  #   gsettings-desktop-schemas
  #   lxappearance

  #   rofi-wayland

  #   xdotool
  # ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = lib.readFile ./hyprland.conf;
    systemdIntegration = true;
    xwayland = true;
  };

  xdg = {
    enable = true;
    configFile = {
      # "xkb/symbols/us".text = ''
      #   partial alphanumeric_keys
      #   xkb_symbols "fkey_fix" {
      #     include "us(basic)";
 
      #     replace key <I191> { [ F13 ] };
      #     replace key <I192> { [ F14 ] };
      #     replace key <I193> { [ F15 ] };
      #     replace key <I194> { [ F16 ] };
      #     replace key <I195> { [ F17 ] };
      #     replace key <I196> { [ F18 ] };
      #     replace key <I197> { [ F19 ] };
      #     replace key <I198> { [ F20 ] };
      #     replace key <I199> { [ F21 ] };
      #   };
      # '';
    };
  };

}
