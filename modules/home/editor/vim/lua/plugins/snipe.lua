return {
	"leath-dub/snipe.nvim",
	opts = {
		ui = {
      position = "cursor",
			persist_tags = true,
		},
	},
	config = function()
		local snipe = require("snipe")
		snipe.ui_select_menu = require("snipe.menu"):new({ position = "center" })
		snipe.ui_select_menu:add_new_buffer_callback(function(m)
			vim.keymap.set("n", "<esc>", function()
				m:close()
			end, { nowait = true, buffer = m.buf })
		end)
		vim.ui.select = snipe.ui_select
	end,
}
