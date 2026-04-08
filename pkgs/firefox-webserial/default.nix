{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  callPackage,

  gcc,

  cjson,
  libserialport,
}:

let
in
stdenv.mkDerivation (finalAttrs: {
  pname = "firefox-webserial";
  version = "0.5.0";

  wsServer = callPackage ./wsServer.nix { };
  uuid4 = fetchFromGitHub {
    name = "uuid4";
    owner = "gpakosz";
    repo = "uuid4";
    rev = "ccd92c53a44594b57eb2085fc20b28bf9a01676b";
    hash = "sha256-wiGClOoSFXK1Q594lyUN0T1auyk04DNrdYuG+adxszU=";
  };
  libserial_internal = fetchFromGitHub {
    owner = "sigrokproject";
    repo = "libserialport";
    rev = "libserialport-0.1.2";
    hash = "sha256-XrcD4avaIV8cqdyv7KZjpotS0/pM6Rt41I3nUesDwTY=";
  };

  src = fetchFromGitHub {
    owner = "kuba2k2";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Os8s3halPrvU/clCc5NCCcq2TcN78YOHPWNs5kjnnCg=";
  };

  sourceRoot = "source/native/src";

  nativeBuildInputs = [
    gcc

    cjson
    libserialport
    finalAttrs.wsServer
  ];

  postUnpack = ''
    cp ${finalAttrs.uuid4}/src/* source/native/src
  '';

  makefile = ./Makefile;

  NIX_CFLAGS_COMPILE = toString [
    "-I${cjson}/include/cjson"
    "-I${libserialport}/include"
    "-I${finalAttrs.libserial_internal}"
    "-I${finalAttrs.uuid4}/src"
    "-I${finalAttrs.wsServer}/include"
    "-I${./.}"
  ];

  PREFIX = placeholder "out";
})
