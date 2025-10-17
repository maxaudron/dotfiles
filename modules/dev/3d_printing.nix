{ config, lib, pkgs, ... }:

let
  conf = import ../config { inherit lib; };
in
{
  config = lib.mkIf (!conf.os.work) {
    home.packages = with pkgs;
      [
        # unstable.prusa-slicer
        (unstable.prusa-slicer.overrideAttrs (prev: {
          patches = [ ./fix-mmu.patch ];
          version = "2.9.3-beta1";
          src = fetchFromGitHub {
            owner = "prusa3d";
            repo = "PrusaSlicer";
            hash = "sha256-oQdXRYrrcuxoVgKziiHjKffXhNBaamVsDy37FZw57LA=";
            rev = "version_2.9.3-beta1";
          };

          buildInputs = prev.buildInputs ++ [
            nlohmann_json
          ];
        }))
      ];
  };
}
