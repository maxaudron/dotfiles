
{ stdenv, lib, fetchFromGitHub, kubectl, openssh, makeWrapper, installShellFiles }:

with lib;

stdenv.mkDerivation rec {
  pname = "kubectl-ssh";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ makeWrapper installShellFiles ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp kubectl-ssh $out/bin
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${makeBinPath [ kubectl openssh ]}
    done

    installShellCompletion --cmd kubectl-ssh \
      --bash ./bash_completion
    runHook postInstall
  '';

  meta = {
    description = "Quickly ssh to cluster nodes";
    license = licenses.isc;
    platforms = with platforms; unix;
  };
}
