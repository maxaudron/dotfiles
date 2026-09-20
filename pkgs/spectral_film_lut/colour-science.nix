{
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  hatch-vcs,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "colour-science";
  pyproject = true;
  version = "0.4.7";
  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "colour";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yu0mmXnCZD1gEuTeo31mRjl+CaMdnaDlltIHf2v57pU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    numpy
  ];
})
