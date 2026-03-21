{
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vim-asciidoctor";
  version = "2025-07-21";
  src = fetchFromGitHub {
    owner = "habamax";
    repo = "vim-asciidoctor";
    rev = "d45364d662489e0ffcad0e2bc6f41c859ba58799";
    hash = "sha256-dTC+a4VmmmUtKUPwFwc9Gwd9ZyxfhQS2oMp7eFBm9Tw=";
  };

  meta.homepage = "https://github.com/habamax/vim-asciidoctor";
  meta.hydraPlatforms = [ ];
}
