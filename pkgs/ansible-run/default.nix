{ stdenv, lib, makeWrapper, perlPackages, perl, coreutils, git, openssh, ansible, hostname, sysctl }:

with lib;

let
  runtimeDeps = [ perl coreutils git openssh ansible hostname sysctl ];
  perlDeps = with perlPackages; [ JSON YAML ];
in stdenv.mkDerivation rec {
  pname = "ansible-run";
  version = "2022-05-23";

  src = fetchGit {
    name = "${pname}-${version}";
    url = "git@git.eu.clara.net:de-platforms-applications/ansible-wrapper";
    rev = "da2e759ba5ff3ade21e873d2500d4697d96980fd";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -d $out/bin
    install -m 755 src/ansible-run $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/ansible-run \
      --set PATH ${makeBinPath runtimeDeps} \
      --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}"
  '';

  meta = {
    description = "Claranet wrapper script to manage ansible executions";
    homepage = "https://git.eu.clara.net/de-ansible-bundles/clara-core";
  };
}
