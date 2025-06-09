return {
  "catppuccin/nvim",
  name = "catppuccin-nvim",
  priority = 1000,
  opts = {
    flavour = "mocha",    -- latte, frappe, macchiato, mocha
    no_italic = true,     -- Force no italic
    no_bold = true,       -- Force no bold
    no_underline = false, -- Force no underline
    styles = {            -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = {},      -- Change the style of comments
      conditionals = {},
    },
    integrations = {
      blink_cmp = {
        style = 'bordered',
      },
      gitsigns = true,
      treesitter_context = true,
      treesitter = true,
      snacks = {
        enabled = true,
        indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
      },
      lsp_trouble = true,
      which_key = true,
    }
  },
  config = function()
    -- load the colorscheme here
    vim.cmd.colorscheme "catppuccin"
  end,
}
