{
  vimUtils,
  vimPlugins,
  fetchFromGitHub,
  mcp-hub,
}:

vimUtils.buildVimPlugin {
  pname = "mcphub.nvim";
  version = "6.2.0";
  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcphub.nvim";
    rev = "v6.2.0";
    hash = "sha256-tJnULDDy2RkhtcfG7N71iJFhTZpdkn3xYZ9aj0dP/pA=";
  };

  dependencies = with vimPlugins; [
    mcp-hub
    plenary-nvim
    lualine-nvim
  ];

  nvimSkipModules = [
    "bundled_build"
  ];

  # postInstall = ''
  #   mkdir -p $out/bin
  #   ln -s ${mcp-hub}/bin/mcp-hub $out/bin/mcp-hub
  # '';

  meta.homepage = "https://github.com/ravitemer/mcphub.nvim";
}

