return {
  'tpope/vim-fugitive',
  cmd = { 'Gvsplit', 'G', 'Gread', 'Git', 'Gedit', 'Gstatus', 'Gdiffsplit', 'Gvdiffsplit' },
  event = { 'CmdwinEnter', 'CmdlineEnter' },
  opts = {},
  config = function() end,
  keys = {
    { "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
    { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
  }
}
