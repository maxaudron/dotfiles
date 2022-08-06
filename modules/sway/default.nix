{ config, lib, pkgs, nixpkgs, system, ... }:

let
  unstable = import nixpkgs {
    inherit system;
    overlays = [
      (import "${
          builtins.fetchGit {
            url = "https://github.com/nix-community/nixpkgs-wayland";
            ref = "master";
            rev = "da508b9e9a6febffc337daaff980e0201dddb12a";
          }
        }/overlay.nix")

      (final: prev: {
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: rec {
          # version = "1.7";
          src = builtins.fetchGit {
            url = "https://github.com/fluix-dev/sway-borders";
            ref = "master";
            rev = "8fba9c0476ac2d1a8a2c640db3234a4c1967ca24";
          };
        });
      })
    ];
  };

  swayPackage = pkgs.sway.override {
    withBaseWrapper = true;
    withGtkWrapper = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM="wayland;xcb"
      # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  sysconfig = (import <nixpkgs/nixos> { }).config;
in {
  imports = [
    ./rofi
    ./waybar

    ./keybinds.nix
    ./input.nix
    ./theme.nix

    # (./specifics + "/${sysconfig.networking.hostName}.nix")
    (./specifics/liduur.nix)
  ];

  # programs.qt5ct.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
    alacritty
    waybar
    seatd

    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    rofi-wayland

    xdotool
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = swayPackage;
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

      # border_images.focused "${./shadows.png}"
      # border_images.focused_inactive "${./shadows.png}"
      # border_images.unfocused "${./shadows.png}"
      # border_images.urgent "${./shadows.png}"
    extraConfig = ''
      xwayland enable
    '';
  };
}
