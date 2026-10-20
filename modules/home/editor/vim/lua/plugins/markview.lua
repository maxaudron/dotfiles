return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = { "saghen/blink.cmp" },

  opts = {
    preview = { enable = false },
    asciidoc = {
      enable = true,
    },
    asciidoc_inline = {
      enable = true,
    },
  },

  keys = {
    { "<leader>mm", "<cmd>Markview<cr>", desc = "Markview Global Toggle" },
    { "<leader>mh", "<cmd>Markview HybridToggle<cr>", desc = "Markview Hybrid Toggle" },
    { "<leader>ml", "<cmd>Markview linewiseToggle<cr>", desc = "Markview Line or Node wise" },
    { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Markview Split View" },
  }
}
