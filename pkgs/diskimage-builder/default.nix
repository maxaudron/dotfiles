{ lib, python310Packages }:

with python310Packages;
buildPythonApplication {
  pname = "diskimage-builder";
  version = "3.25.0";

  propagatedBuildInputs = [ setuptools networkx pbr pyyaml stevedore flake8 ];

  nativeBuildInputs = with pkgs; [ getopt qemu-utils ];
  doCheck = false;

  src = python310Packages.fetchPypi {
    pname = "diskimage-builder";
    version = "3.25.0";
    hash = "sha256-kaiQQQbmacDKmQQUV1HFaxkmozJeE+lO9UitUJIMSCw=";
  };
}
