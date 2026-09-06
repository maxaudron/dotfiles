{
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "yoga";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "react";
    repo = "yoga";
    rev = "v${version}";
    hash = "sha256-y7tLHOfZ/S5ZAdtL8TXTNMwj76QH+alYBaI8e3Wc4iU=";
  };

  doCheck = false;

  postPatch = ''
    # tests are fetched/generated via network (googletest FetchContent) - disable
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' '#add_subdirectory(tests) disabled for nix build'
'';

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DYOGA_BUILD_TESTS=OFF"   # gentest fixtures are generated via Chrome; skip
    "-DYOGA_BUILD_BENCHMARKS=OFF"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];
}
