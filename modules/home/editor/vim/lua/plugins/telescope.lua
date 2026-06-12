local builtin = require("telescope.builtin")

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim" },
		{ "mrcjkb/telescope-manix" },
	},

	opts = {
		pickers = {
			buffers = {
				theme = "ivy",
			},
		},
	},
	keys = {
		{ "<leader><space>", builtin.find_files, desc = "Find Files" },
		{ "<leader>/", builtin.live_grep, desc = "Search Files" },
		{ "<leader>,", builtin.buffers, desc = "Buffers" },
		{ "<leader>th", builtin.help_tags, desc = "Help Tags" },
		{ "<leader>tm", builtin.man_pages, desc = "Help Tags" },
		{ "<leader>tk", builtin.keymaps, desc = "Keymaps" },
		{ "<leader>tc", builtin.planets, desc = "planets" },
		{ "<leader>tn", require("telescope-manix").search, desc = "nix search" },
	},
}
