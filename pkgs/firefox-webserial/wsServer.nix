{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wsServer";
  version = "2023-05-03";

  src = fetchFromGitHub {
    owner = "Theldus";
    repo = finalAttrs.pname;
    rev = "476a67448c05ba2057bae43eaa6e704f8b2d6625";
    hash = "sha256-irPEv40uTmQPQ09ITFoUzl44BeWOCVnsHPioE4Zt6SE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  installPhase = ''
    mkdir -p $out/lib $out/include
    cp libws.a $out/lib

    pushd ${finalAttrs.src}/include
      find . -type f -exec install -Dm 755 "{}" "$out/include/{}" \;
    popd
  '';
})
