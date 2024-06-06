{ stdenv, lib, fetchFromGitLab, makeWrapper, buildGoModule, file, glibc }:

with lib;

buildGoModule rec {
  pname = "bootstrap";
  version = "1.0.3";

  src = fetchGit {
    name = "bootstrap-${version}";
    url = "git@git.eu.clara.net:de-project-bootstrapping/tooling/${pname}";
    ref = "refs/tags/${version}";
    rev = "7f8484385d19f0a59d4b9ac4a3f298dc55d22027";
  };

  buildInputs = [ stdenv file ];
  cflags = [ "-I ${file}/include" ];
  ldflags = [ "-L ${file}/lib" ];

  vendorHash = "sha256-8hhJM4jXCpXtTvVe8w8TyVm8qACjVKBiV7R9Ievclp8=";

  meta = {
    description = "Bootstrap new projects based on templates";
    homepage =
      "https://git.eu.clara.net/de-project-bootstrapping/tooling/bootstrap";
  };
}
