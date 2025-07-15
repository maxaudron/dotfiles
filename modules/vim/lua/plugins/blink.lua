return {
  'saghen/blink.cmp',
  -- -- optional: provides snippets for the snippet source
  -- dependencies = { 'rafamadriz/friendly-snippets' },
  dependencies = {
    'Kaiser-Yang/blink-cmp-avante',
    -- ... Other dependencies
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },

    completion = {
      documentation = {
        auto_show = false
      },

      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },

      ghost_text = {
        enabled = false,
        show_with_menu = true,
      },
    },

    signature = { enabled = true },

    sources = {
      default = { 'lsp', 'avante', 'path', 'snippets', 'buffer' },
      providers = {
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
          opts = {
            -- options for blink-cmp-avante
          }
        }
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
