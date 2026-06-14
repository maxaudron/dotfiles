return {
	"mrcjkb/rustaceanvim",
	lazy = false, -- This plugin is already lazy

	config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        test_executor = "background"
      },
      -- LSP configuration
      server = {
        settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            diagnostics = {
              disabled = {
                "inactive-code",
              },
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            }
          },
        },
      },
      -- DAP configuration
      dap = {},
    }
	end,
	keys = {
		{ "<leader>cm", function () vim.cmd.RustLsp('expandMacro') end, desc = "Expand Macro" },
		{ "<leader>cd", desc = "Diagnostics" },
		{ "<leader>cdr", function () vim.cmd.RustLsp('relatedDiagnostics') end, desc = "Related" },
		{ "<leader>co", function () vim.cmd.RustLsp('openDocs') end, desc = "docs.rs" },
		{ "<leader>cj", function () vim.cmd.RustLsp('joinLines') end, desc = "Join Lines" },
	},
}
