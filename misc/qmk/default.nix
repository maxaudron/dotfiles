{
  lib,
  stdenv,
  python3,
  qmk,
  git,
  elf2uf2-rs,
  fetchFromGitHub,

  left ? true,
  keymap ? "audron",
}:

stdenv.mkDerivation rec {
  pname = "qmk_redox_audron";
  version = "0.1.0";

  srcs = [
    (fetchFromGitHub {
      owner = "qmk";
      repo = "qmk_firmware";
      rev = "9e8199c41189a2eb6243600bf3f96f136650820b";
      hash = "sha256-QAU/BPqfKQiMawjzOuxM4iwMlkWleADrJJNoCWPgejw=";
      fetchSubmodules = true;
    })
    ./keyboards
  ];

  sourceRoot = "./source";

  postUnpack = ''
    cp -r keyboards/* $sourceRoot/keyboards
    chmod -R u+rw $sourceRoot/keyboards/redox
  '';

  nativeBuildInputs = [ qmk ];

  doCheck = false;

  SKIP_GIT = "yes";

  postPatch = ''
    sed -i -e "s|#!/usr/bin/env python3|#!${python3}/bin/python3|" util/uf2conv.py

    ${
      if left then
        ""
      else
        "sed -i -e '0,/RX/s/GP3/GP2/' -e '0,/TX/s/GP2/GP3/' keyboards/redox/rev1/pm2040/config.h"
    }
  '';

  buildPhase = ''
    qmk -v compile -kb redox/rev1/pm2040 -km ${keymap}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp redox_rev1_pm2040_audron.uf2 $out/
  '';
}
