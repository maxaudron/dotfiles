{ stdenv, lib, curl, jq, pass, makeWrapper }:

stdenv.mkDerivation {
  pname = "llm-usage";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 llm-usage $out/bin/llm-usage
    wrapProgram $out/bin/llm-usage \
      --prefix PATH : ${lib.makeBinPath [ curl jq pass ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Display LiteLLM virtual key usage and budget";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
