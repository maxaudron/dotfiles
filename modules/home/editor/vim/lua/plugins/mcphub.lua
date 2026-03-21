return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("mcphub").setup()
	end,

	keys = {
		{ "<leader>am", "<cmd>MCPHub<cr>", desc = "Show MCPHub" },
		{ "<leader>as", "<cmd>!open http://127.0.0.1:24282/dashboard/<cr>", desc = "Open Serena Dashboard" },
	},
}
