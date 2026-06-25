local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", { capabilities = capabilities })
vim.lsp.config("css", { capabilities = capabilities })

local files = vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)
for k, v in ipairs(files) do
	local name = vim.fs.basename(v):sub(1, -5)
	vim.lsp.config[name] = require("lsp/" .. name)
	vim.lsp.enable(name)
end

local lsp = {
	"bashls"
  -- C
,	"clangd"
  -- go
,	"gopls"
  -- lua
,	"lua_ls"
,	"stylua"
  -- nix
,	"nil_ls"
  -- python
,	"ruff"
,	"pyright"
  -- QT
,	"qmlls"
  -- terraform
,	"terraformls"
	-- "rust_analyzer"
	-- web

  -- rust
,	"html"
,	"cssls"
}

for _, s in ipairs(lsp) do
	vim.lsp.enable(s)
end


vim.g.rustaceanvim = {
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
        },
      },
    },
  },
  -- DAP configuration
  dap = {},
}
