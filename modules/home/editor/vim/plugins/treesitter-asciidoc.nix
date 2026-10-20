{ buildGrammar, fetchFromGitHub, ... }:

buildGrammar {
  language = "asciidoc";
  version = "2026-09-29";
  src = fetchFromGitHub {
    owner = "cathaysia";
    repo = "tree-sitter-asciidoc";
    rev = "ade998931aeac0a10ca592b421cdb1f2f088f6c9";
    hash = "sha256-Q6HEiJhNNlqx6haAXl4O6GQSVlLPIBSLmGCmB0Xcrfo=";
  } + "/tree-sitter-asciidoc";
  meta.homepage = "https://github.com/cathaysia/tree-sitter-asciidoc";
}
