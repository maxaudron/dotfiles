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
	},
}
