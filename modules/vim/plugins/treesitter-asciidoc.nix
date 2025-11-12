{ buildGrammar, fetchFromGitHub, ... }:

buildGrammar {
  language = "asciidoc";
  version = "2025-10-20";
  src = fetchFromGitHub {
    owner = "cathaysia";
    repo = "tree-sitter-asciidoc";
    rev = "061c155918fa271aede35d451ab701b014f3386c";
    hash = "sha256-QuUq736vO+Zrt8rKwT56HXnG72UekiX5KNYwa0peJXg=";
  } + "/tree-sitter-asciidoc";
  meta.homepage = "https://github.com/cathaysia/tree-sitter-asciidoc";
}
