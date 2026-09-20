{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  hatch-vcs,

  callPackage,
  imageio,
  matplotlib,
  networkx,
  numba,
  numpy,
  pyqt6,
  scipy,

  opencv5
}:

buildPythonPackage (finalAttrs: {
  pname = "spectral_film_lut";
  pyproject = true;
  version = "0.16.0";
  src = fetchFromGitHub {
    owner = "JanLohse";
    repo = "spectral_film_lut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9eFGuSk+mMPiUb85hsdoPjx6me8YOJREgbG9z7f/xis=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    (callPackage ./colour-science.nix { })
    (imageio.overrideAttrs (
      prev: final: {
        version = "2.37.4";

        src = fetchFromGitHub {
          owner = "imageio";
          repo = "imageio";
          tag = "v2.37.4";
          hash = "sha256-7UiKj/PH3eVa8Qa8zz5FJ2RmFHcL19THwSLY51tdy2I=";
        };
      }
    ))
    matplotlib
    networkx
    numba
    numpy
    opencv5
    (callPackage ./opencv5/opencv-python.nix { inherit opencv5; })
    pyqt6
    scipy
  ];
})
