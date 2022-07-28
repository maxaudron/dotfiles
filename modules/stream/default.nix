{ config, lib, pkgs, ... }:

let looking-glass-client = pkgs.looking-glass-client.overrideAttrs (prev: {
      version = "B5-413-eb1774f9";
      src = pkgs.fetchFromGitHub {
        owner = "gnif";
        repo = "LookingGlass";
        rev = "eb1774f955eb194220e3d51ae320b6a0d56eb131";
        sha256 = "sha256-CPBrIBw7oCs5v4kmoQ9f1iuWML6uueOLEmaNKh2tI44=";
        fetchSubmodules = true;
      };

      buildInputs = prev.buildInputs ++ [
        pkgs.pipewire.dev
        pkgs.libpulseaudio.dev
        pkgs.libsamplerate.dev
      ];
    });

    looking-glass-obs = pkgs.obs-studio-plugins.looking-glass-obs.overrideAttrs (prev: {
      version = looking-glass-client.version;

      src = looking-glass-client.src;
    });
in {
  home.packages = with pkgs; [
    looking-glass-client
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [
      looking-glass-obs
    ];
  };
}
