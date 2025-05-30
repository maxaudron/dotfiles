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
    }
  },
  config = function()
    -- load the colorscheme here
    vim.cmd.colorscheme "catppuccin"
  end,
}
