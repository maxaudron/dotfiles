{
  vimUtils,
  fetchFromGitHub,
  lib,
}:

vimUtils.buildVimPlugin {
  pname = "git-link.nvim";
  version = "2026-06-15";
  src = fetchFromGitHub {
    owner = "juacker";
    repo = "git-link.nvim";
    rev = "8f8cc20edd353f51dd049ac3cf2c6ddcce1f1c53";
    hash = "sha256-H229bUA4uj87gc0Obbk/JSyI5HRZEobFEdvS5jy7nO0=";
  };

  nvimSkipModules = [
    # "bundled_build"
  ];

  meta.homepage = "https://github.com/juacker/git-link.nvim";
}

