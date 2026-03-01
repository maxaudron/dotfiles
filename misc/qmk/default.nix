{
  lib,
  stdenv,
  python3,
  qmk,
  git,
  elf2uf2-rs,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "qmk_redox_audron";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = "9e8199c41189a2eb6243600bf3f96f136650820b";
    hash = "sha256-QAU/BPqfKQiMawjzOuxM4iwMlkWleADrJJNoCWPgejw=";
    fetchSubmodules = true;
  };

  # Additional source from local directory
  localSrc = ./.;

  postUnpack = ''
    cp -r $localSrc/* $sourceRoot/
  '';

  nativeBuildInputs = [ qmk ];

  doCheck = false;

  SKIP_GIT = "yes";

  postPatch = ''
    sed -i -e "s|#!/usr/bin/env python3|#!${python3}/bin/python3|" util/uf2conv.py
  '';

  buildPhase = ''
    qmk -v compile -kb redox/rev1/pm2040 -km audron
    cp redox_rev1_pm2040_audron.uf2 redox_rev1_pm2040_audron_left.uf2
    qmk -v compile -kb redox/rev1/pm2040 -km audron
    cp redox_rev1_pm2040_audron.uf2 redox_rev1_pm2040_audron_right.uf2
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp redox_rev1_pm2040_audron_left.uf2 $out/
    cp redox_rev1_pm2040_audron_right.uf2 $out/
  '';
}
