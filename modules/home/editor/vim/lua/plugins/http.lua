local user = os.getenv("USER") or "audron"
local bin_path = string.format("/etc/profiles/per-user/%s/bin/kulala-core", user)
local file = io.open(bin_path, "r")
if file then
	file:close()
else
	bin_path = string.format("/home/%s/.nix-profile/bin/kulala-core", user)
end

return {
	"mistweaverco/kulala.nvim",
	-- Load before session save/restore so VimLeavePre and SessionLoadPost hooks are registered.
	event = { "SessionLoadPost", "VimLeavePre" },
	-- See opts.lsp.enforce_external_script_naming_convention
	-- to restrict LSP capabilities to *.http, *.http.js, *.http.ts and *.http.lua files.
	ft = { "http", "rest", "javascript", "lua" },
	init = function()
		vim.treesitter.language.register("kulala_http", { "http", "rest" })
	end,
	keys = {
		{ "<leader>h", desc = "kulala" },
	},
	opts = {
		kulala_core = {
			path = bin_path,
			data_dir = nil,
			download_url = "",
		},
		treesitter = {
			enable = false,
		},
		ui = {
			-- display mode: possible values: "split", "float"
			display_mode = "split",
			-- split direction: possible values: "above", "right", "below", "left", fun(): "above"|"right"|"below"|"left"
			split_direction = "right",
			-- window options to override win_config: width/height/split/vertical.., buffer/window options
			---@type kulala.ui.win_config
			win_opts = {
				bo = {},
				wo = {
					foldmethod = "indent",
					foldminlines = 100,
				},
			},

			-- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
			default_view = "body", ---@type "body"|"headers"|"headers_body"|"verbose"|fun(response: Response)
		},

		lsp = {
			---enable/disable built-in LSP server
			---@type boolean
			enable = true,

			---filetypes to attach Kulala LSP to
			---@type string[]
			filetypes = {
				"http",
				"rest",
				"javascript",
				"typescript",
				"lua",
			},
		},

		-- set to true to enable default keymaps
		-- (see docs or lua/kulala/config/keymaps.lua)
		-- or override default keymaps as shown in the example below.
		---@type boolean|table
		global_keymaps = true,

		-- Prefix for global keymaps
		global_keymaps_prefix = "<leader>h",

		kulala_keymaps = {
			["Previous tab"] = {
				"ml",
				function()
					require("kulala.ui").show_previous_tab()
				end,
				mode = { "n" },
			},
			["Next tab"] = {
				"ml",
				function()
					require("kulala.ui").show_next_tab()
				end,
				mode = { "n" },
			},
		},
	},
}
