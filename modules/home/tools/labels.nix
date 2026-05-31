{ lib, pkgs, ... }:

{
  home.packages = [
    (pkgs.python312Packages.brother-ql.overrideAttrs (
      prev: final: rec {
        version = "1.3";
        src = pkgs.fetchPypi {
          pname = "brother-ql-inventree";
          version = version;
          hash = lib.fakeHash;
        };
      }
    ))
  ];
}
