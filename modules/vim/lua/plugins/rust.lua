return {
	"mrcjkb/rustaceanvim",
	lazy = false, -- This plugin is already lazy

	config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {},
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
		{ "<leader>ct", desc = "Tests" },
		{ "<leader>ctt", function () vim.cmd.RustLsp('testables') end, desc = "Run All Tests" },
		{ "<leader>ctl", function () vim.cmd.RustLsp { 'testables', bang = true } end, desc = "Run All Tests" },
		{ "<leader>ctr", function () vim.cmd.RustLsp('run') end, desc = "Run Under Cursor" },
		{ "<leader>cm", function () vim.cmd.RustLsp('expandMacro') end, desc = "Expand Macro" },
		{ "<leader>cd", desc = "Diagnostics" },
		{ "<leader>cdr", function () vim.cmd.RustLsp('relatedDiagnostics') end, desc = "Related" },
		{ "<leader>co", function () vim.cmd.RustLsp('openDocs') end, desc = "docs.rs" },
		{ "<leader>cj", function () vim.cmd.RustLsp('joinLines') end, desc = "Join Lines" },
	},
}
