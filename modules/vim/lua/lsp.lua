local files = vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)
for k, v in ipairs(files) do
	local name = vim.fs.basename(v):sub(1, -5)
	vim.lsp.config[name] = require("lsp/" .. name)
	vim.lsp.enable(name)
end

local lsp = {
  "bashls"
  -- C
  , "clangd"
  -- go
  , "gopls"
  -- lua
  , "lua_ls"
  , "stylua"
  -- nix
  , "nil_ls"
  -- python
  , "ruff"
  , "pyright"
  -- QT
  , "qmlls"
  -- terraform
  , "terraformls"
}

for _, s in ipairs(lsp) do
  vim.lsp.enable(s)
end
