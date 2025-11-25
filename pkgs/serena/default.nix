{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,

  click,
  requests,
  pyright,
  overrides,
  python-dotenv,
  pytest-dotenv,
  flask,
  pydantic,
  types-pyyaml,
  pyyaml,
  ruamel-yaml,
  jinja2,
  pathspec,
  psutil,
  docstring-parser,
  joblib,
  tqdm,
  tiktoken,
  anthropic,
  mcp,
  sensai-utils,
}:

buildPythonPackage rec {
  name = "serena";
  version = "d58dbeb";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = version;
    hash = "sha256-+DBo8r5k6FeGjLWEDtYfUdrmugmMqlfG8CgjYs02rls=";
  };

  patches = [ ./loosen-deps.patch ];

  build-system = [ hatchling ];

  pythonRuntimeDepsCheck = false;

  nativeCheckInputs = [
  ];

  propagatedBuildInputs = [
    click
    requests
    pyright
    overrides
    python-dotenv
    pytest-dotenv
    flask
    pydantic
    types-pyyaml
    pyyaml
    ruamel-yaml
    jinja2
    pathspec
    psutil
    docstring-parser
    joblib
    tqdm
    tiktoken
    anthropic
    python-dotenv
    mcp
    sensai-utils
  ];
}






