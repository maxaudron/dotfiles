
{ stdenv, lib, fetchFromGitHub, kubectl, makeWrapper }:

with lib;

stdenv.mkDerivation rec {
  pname = "kubectl-netshoot";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ makeWrapper ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp kubectl-netshoot $out/bin
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${makeBinPath [ kubectl ]}
    done
  '';

  meta = {
    license = licenses.isc;
    platforms = with platforms; unix;
  };
}
