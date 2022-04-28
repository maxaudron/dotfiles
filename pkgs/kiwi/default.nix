{ lib, python3Packages }:

with python3Packages;

buildPythonApplication {
  pname = "kiwi";
  version = "9.24.32";

  propagatedBuildInputs = [ docopt lxml pyxattr requests pyyaml simplejson ];

  src = python3Packages.fetchPypi {
    format = "setuptools";
    pname = "kiwi";
    version = "9.24.32";
    hash = "sha256:c3017a641b0ae6f2e61629ec452db918b11434fb6fc4d008a603ba5b6ca1f481";
  };
}
