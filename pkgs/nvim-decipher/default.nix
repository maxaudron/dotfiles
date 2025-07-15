{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "decipher.nvim";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "MisanthropicBit";
    repo = "decipher.nvim";
    rev = "f30f86b01004a09eb6af55c1059cfd8d52f53f64";
    hash = "sha256-U8womBye4c4lgHbpvOr2qK3Y5tiOAJYknSIKtWgfSew=";
  };

  nvimSkipModules = [
    "decipher.util.vader"
  ];

  meta.homepage = "https://github.com/MisanthropicBit/decipher.nvim";
  meta.hydraPlatforms = [ ];
}
