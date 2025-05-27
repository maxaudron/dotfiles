{
  config,
  lib,
  pkgs,
  gtree,
  system,
  ...
}:

{
  home.shellAliases = {
    v = "nvim";
  };

  home.packages = [
    pkgs.lua-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = lib.fileContents ./init.lua;

    plugins = with pkgs.vimPlugins; [
      { plugin = catppuccin-nvim; }
      { plugin = snacks-nvim; }
      { plugin = which-key-nvim; }
      { plugin = project-nvim; }
    ];
  };
}
