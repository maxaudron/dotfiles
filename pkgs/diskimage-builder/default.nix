{ lib, python3Packages }:

with python3Packages;
let nativeBuildInputs = with pkgs; [ getopt qemu-utils util-linux bash ];
in buildPythonApplication {
  pname = "diskimage-builder";
  version = "3.25.0";

  patches = [ ./disk_image_create.patch ];

  propagatedBuildInputs = [ setuptools networkx pbr pyyaml stevedore ];
  buildInputs =
    [ flake8 yamllint coverage testtools stestr oslotest mock pylint ];

  nativeBuildInputs = nativeBuildInputs;
  doCheck = false;

  makeWrapperArgs =
    [ "--prefix-each PATH : ${lib.makeBinPath nativeBuildInputs}" ];

  src = python3Packages.fetchPypi {
    pname = "diskimage-builder";
    version = "3.25.0";
    hash = "sha256-kaiQQQbmacDKmQQUV1HFaxkmozJeE+lO9UitUJIMSCw=";
  };
}
