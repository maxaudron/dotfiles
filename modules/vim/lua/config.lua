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

vim.filetype.add { extension = { qss = 'css' } }
