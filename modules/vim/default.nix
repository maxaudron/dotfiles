{
  config,
  lib,
  pkgs,
  gtree,
  system,
  ...
}:

let
  conf = import ../config { inherit lib; };
in
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

    # extraLuaConfig = lib.fileContents ./init.lua;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      catppuccin-nvim
      snacks-nvim

      which-key-nvim
      mini-icons

      gitsigns-nvim
      blink-cmp
      blink-cmp-avante

      render-markdown-nvim
      pkgs.unstable.vimPlugins.avante-nvim
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      require("lazy").setup({
        spec = {
          -- import your plugins
          { import = "plugins" },
        },
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false
          }
        },
        pkg = { enabled = false },
        rocks = { enabled = false },
        dev = {
          path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
          patterns = {""} -- Specify that all of our plugins will use the dev dir. Empty string is a wildcard!
        },
        install = {
          -- Safeguard in case we forget to install a plugin with Nix
          missing = false,
        }
      })

      require("init")
    '';
    };

    xdg.configFile."nvim/lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${conf.user.home}/.dotfiles/modules/vim/lua";
    };
}
