require("config")
require("keymap")

local files = vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)
for k, v in ipairs(files) do
  local name = vim.fs.basename(v):sub(1, -5)
  vim.lsp.config[name] = require("lsp/" .. name)
  vim.lsp.enable(name)
end


