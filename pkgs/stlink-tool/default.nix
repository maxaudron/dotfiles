{ stdenv, lib, fetchFromGitHub, kubectl, makeWrapper, pkg-config, libusb1 }:

with lib;

stdenv.mkDerivation rec {
  pname = "stlink-tool";
  version = "stlinkv21";

  src = fetchFromGitHub {
    owner = "UweBonnes";
    repo = pname;
    rev = "refs/heads/${version}";
    hash = "sha256-Wj72kHckxnox0kfqEZzE5zeSi8Bc+QSHPs4BtIf6RhE=";
    fetchSubmodules = true;
  };

  buildInputs = [ makeWrapper pkg-config libusb1 ];

  installPhase = ''
    install -d $out/bin
    install -m 755 ${pname} $out/bin
  '';

  meta = {
    description = "Firmware uploader for ST-Link";
    license = licenses.mit;
    homepage = "https://github.com/UweBonnes/stlink-tool";
    platforms = with platforms; unix;
  };
}
