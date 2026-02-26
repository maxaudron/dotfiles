{
  config,
  lib,
  pkgs,
  system,
  mcphub-nvim,
  ...
}:

let
  conf = import ../config { inherit lib; };

  vimPlugins = {
    nvim-decipher = pkgs.callPackage ./plugins/decipher.nix { };
    asciidoctor = pkgs.callPackage ./plugins/asciidoctor.nix { };
    treesitter-asciidoc = pkgs.callPackage ./plugins/treesitter-asciidoc.nix {
      buildGrammar = pkgs.tree-sitter.buildGrammar;
    };
    nvim-treesitter-asciidoc = { };
    mcphub = mcphub-nvim.packages."${system}".default;
  };
in
{
  imports = [ ./mcp.nix ];

  home.shellAliases = {
    v = "nvim";
  };

  home.packages = with pkgs; [
    ruff
    lua-language-server
    stylua
    bash-language-server
    terraform-ls
    gopls
    kdePackages.qtdeclarative
    vscode-langservers-extracted

    # lint
    tflint
    yamllint
    isort
    black

    himalaya

    asciidoctor-with-extensions

    gemini-cli
    unstable.claude-code
    unstable.claude-code-acp
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins =
      with pkgs.vimPlugins;
      with vimPlugins;
      [
        lazy-nvim
        catppuccin-nvim
        snacks-nvim
        conform-nvim
        plenary-nvim

        which-key-nvim
        mini-icons
        nvim-web-devicons

        vim-fugitive
        gitsigns-nvim
        blink-cmp
        blink-cmp-avante
        nvim-lint

        asciidoctor
        render-markdown-nvim
        wrapping-nvim

        pkgs.unstable.vimPlugins.codecompanion-nvim
        pkgs.unstable.vimPlugins.codecompanion-spinner-nvim
        pkgs.unstable.vimPlugins.codecompanion-history-nvim
        pkgs.unstable.vimPlugins.mcphub-nvim

        trouble-nvim
        lualine-nvim

        nvim-highlight-colors
        rainbow-delimiters-nvim
        mini-surround
        mini-pairs
        mini-snippets

        nvim-decipher

        himalaya-vim

        nvim-lspconfig

        hex-nvim
        orgmode

        # Languages
        rustaceanvim
        neotest
        vim-ledger

        # treesitter
        (nvim-treesitter.withPlugins (
          p: with p; [
            python
            rust
            luap
            nix
            markdown
            markdown_inline
            latex
            html
            css
            bash
            qmljs
            tera
            terraform
            styled
            ron
            treesitter-asciidoc
            ledger
          ]
        ))
        nvim-treesitter-context
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

  xdg.configFile = {
    "nvim/lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${conf.user.home}/.dotfiles/modules/vim/lua";
    };
    "nvim/queries" = {
      source = config.lib.file.mkOutOfStoreSymlink "${conf.user.home}/.dotfiles/modules/vim/queries";
    };
  };
}
