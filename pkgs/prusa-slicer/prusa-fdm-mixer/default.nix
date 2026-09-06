{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prusa-fdm-mixer";
  version = "20260907";
  # Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
  # on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
  # with --cores 32 on clang).
  src = "${fetchFromGitHub {
    owner = "prusa3d";
    repo = "prusa-fdm-mixer";
    hash = "sha256-hHCWReD/NNYy6KrS+min/zYxvci2SKq2whHZQ2IFFj4=";
    rev = "46a0d3b1dc39c6288950bd4b62bfab3380e6ea57";
  }}/cpp";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];


  postPatch = ''
    cp ${./CMakeLists.txt} CMakeLists.txt
    cp ${./Config.cmake.in} Config.cmake.in
  '';
})
