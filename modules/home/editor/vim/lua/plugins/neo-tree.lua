return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	lazy = false, -- neo-tree will lazily load itself
  keys = {
		{ "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Neotree", },
		{ "<leader>bb", "<cmd>Neotree toggle buffers bottom<cr>", desc = "Neotree", },
		{ "<leader>bb", "<cmd>Neotree toggle buffers bottom<cr>", desc = "Neotree", },
  },
}
