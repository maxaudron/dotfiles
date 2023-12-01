{ stdenv, lib, buildGoModule, fetchFromGitHub, kubectl, makeWrapper }:

with lib;

buildGoModule rec {
  pname = "kube-review";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "anderseknert";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DueH+aFXgU1y9hCvepn4km+ZxayGwXCf1ytLhLeSzz0=";
  };

  vendorHash = "sha256-L84xfUkLBgYzhOj/jFSOSmYzS86W5ruV+yE50XY0E2Q=";
}
