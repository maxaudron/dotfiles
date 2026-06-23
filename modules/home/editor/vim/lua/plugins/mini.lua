return {
	"nvim-mini/mini.nvim",
	version = false, -- Never set this value to "*"! Never!
	init = function()
		-- Text editing
		require("mini.align").setup({})
		require("mini.move").setup({})
		require("mini.pairs").setup({
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		})
		require("mini.snippets").setup({
			snippets = {
				-- Load snippets based on current language by reading files from
				-- "snippets/" subdirectories from 'runtimepath' directories.
				require("mini.snippets").gen_loader.from_lang(),
			},
		})
		require("mini.surround").setup({})
		require("mini.operators").setup({})

		-- General Workflow
		require("mini.bufremove").setup({})

		-- Appearance
		require("mini.animate").setup({
			scroll = {
				enable = false,
			},
		})
		require("mini.bracketed").setup({})
		require("mini.cursorword").setup({})
		require("mini.hipatterns").setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				depre = { pattern = "%f[%w]()DEPRECATED()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
				review = { pattern = "%f[%w]()REVIEW()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
		require("mini.indentscope").setup({})
		require("mini.notify").setup({
			lsp_progress = {
				enable = false,
			},
		})
		require("mini.trailspace").setup({})
	end,

	keys = {
		-- Top Pickers & Explorer
		{ "<leader>bd", function() MiniBufremove.wipeout() end, desc = "Delete Buffer" },
	},
}
