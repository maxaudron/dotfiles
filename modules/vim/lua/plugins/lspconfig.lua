return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = { },
  config = vim.schedule_wrap(function(_, opts) end),
}
