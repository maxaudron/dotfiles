{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "mcp-hub";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcp-hub";
    rev = "v${version}";
    hash = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
  };

  npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g=";

  npmBuildScript = "build";

  meta = {
    description = "MCP Hub CLI tool";
    homepage = "https://github.com/ravitemer/mcp-hub";
    license = lib.licenses.mit;
  };
}

