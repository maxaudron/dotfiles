{ stdenv, lib, curl, jq, kubectl, pass, makeWrapper }:

stdenv.mkDerivation {
  pname = "kubectl-rancher";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 kubectl-rancher $out/bin/kubectl-rancher
    wrapProgram $out/bin/kubectl-rancher \
      --prefix PATH : ${lib.makeBinPath [ curl jq kubectl pass ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Refresh kubectl kubeconfig from Rancher API for the current context";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
