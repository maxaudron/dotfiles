return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			win_split_mode = "auto",

			org_agenda_files = "~/.org/**/*",
			org_default_notes_file = "~/.org/refile.org",
      org_startup_indented = true,
      org_hide_emphasis_markers = true,
      org_hide_leading_stars = true,

			org_todo_keywords = { "TODO(t)", "NEXT(n)", "DOING(w)", "|", "DONE(d)", "DELEGATED(o)", "CANCLED(x)" },
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
		{ "<leader>ot", "<cmd>edit ~/.org/todo.org<cr>", desc = "Open Todo" },
	},
}
