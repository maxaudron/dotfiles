return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			win_split_mode = "auto",

			org_agenda_files = "~/.org/**/*",
			org_default_notes_file = "~/.org/refile.org",

			org_todo_keywords = { "TODO", "WAITING", "NEXT", "|", "DONE", "DELEGATED", "CANCLED" },
			org_capture_templates = {
				t = {
					description = "Todo",
					template = "* TODO %?\n %u",
					target = "~/.org/todo.org",
				},
			},
		})
		-- Experimental LSP support
		vim.lsp.enable("org")
	end,
	keys = {
		-- { "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
		-- { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
		-- { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
		-- { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
	},
}
