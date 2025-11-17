vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard


vim.opt.cursorline = true    -- Enable highlighting of the current line
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.signcolumn = "yes"   -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true     -- Don't ignore case with capitals
vim.opt.smartindent = true   -- Insert indents automatically
vim.opt.termguicolors = true -- True color support
vim.opt.pumblend = 10        -- Popup blend
vim.opt.pumheight = 10       -- Maximum number of entries in a popup
vim.opt.shiftround = true    -- Round indent
vim.opt.shiftwidth = 2       -- Size of an indent
vim.opt.tabstop = 2          -- Size of a tab
vim.opt.softtabstop = 2      -- Size of a tab
vim.opt.exrc = true          -- allow loading directory vimrc files

vim.opt.wrap = true
vim.opt.textwidth = 0
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳"

vim.filetype.add { extension = { qss = 'css' } }

vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.api.nvim_create_augroup('UserGroup', {})

-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'UserGroup',
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})
