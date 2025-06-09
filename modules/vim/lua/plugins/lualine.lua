local palette = require("catppuccin.palettes").get_palette "mocha"

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local leftbar = {
  function()
    return '▊'
  end,
  color = { fg = palette.lavender },     -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

local mode = {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = palette.red,
      i = palette.green,
      v = palette.blue,
      [''] = palette.blue,
      V = palette.blue,
      c = palette.yellow,
      no = palette.red,
      s = palette.peach,
      S = palette.peach,
      [''] = palette.peach,
      ic = palette.yellow,
      R = palette.mauve,
      Rv = palette.mauve,
      cv = palette.red,
      ce = palette.red,
      r = palette.sapphire,
      rm = palette.sapphire,
      ['r?'] = palette.sapphire,
      ['!'] = palette.red,
      t = palette.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

local filesize = {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

local filename = {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = palette.text, gui = 'bold' },
}

local progress = { 'progress', color = { fg = palette.text, gui = 'bold' } }

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    error = { fg = palette.red },
    warn = { fg = palette.peach },
    info = { fg = palette.sapphire },
  },
}

local lsp = {
  -- Lsp server name .
  function()
    local no_lsp = ''
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return no_lsp
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return no_lsp
  end,
  icon = ' ',
  color = { fg = palette.text, gui = 'bold' },
}


return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  opts = {
    options = {
      -- Disable sections and component separators
      component_separators = '',
      section_separators = '',
      theme = {
        -- We are going to use lualine_c an lualine_x as left and
        -- right section. Both are highlighted by c theme .  So we
        -- are just setting default looks o statusline
        normal = {
          a = { fg = palette.text, bg = palette.mantle },
          b = { fg = palette.text, bg = palette.mantle },
          c = { fg = palette.text, bg = palette.mantle }
        },
        inactive = {
          a = { fg = palette.text, bg = palette.mantle },
          b = { fg = palette.text, bg = palette.mantle },
          c = { fg = palette.text, bg = palette.mantle }
        },
      },

    },
    sections = {
      lualine_a = { leftbar, mode, },
      lualine_b = {
        filesize,
        {
          'branch',
          icon = '',
          color = { fg = palette.mauve, gui = 'bold' },
        },
        filename, 'location'
      },
      lualine_c = { '%=', diagnostics },

      lualine_x = {},
      lualine_y = { lsp },
      lualine_z = {
        {
          'o:encoding',       -- option component same as &encoding in viml
          fmt = string.upper, -- I'm not sure why it's upper case either ;)
          cond = conditions.hide_in_width,
          color = { fg = palette.green, gui = 'bold' },
        },
        {
          'fileformat',
          fmt = string.upper,
          icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
          color = { fg = palette.green, gui = 'bold' },
        },
        {
          function()
            return '▊'
          end,
          color = { fg = palette.lavender },
          padding = { left = 1 },
        }
      },

    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }
}
