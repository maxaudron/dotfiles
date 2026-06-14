local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set( "n", "g.", function() vim.cmd.RustLsp('codeAction') end, { silent = true, buffer = bufnr })
vim.keymap.set( "n", "K", function() vim.cmd.RustLsp({'hover', 'actions'}) end, { silent = true, buffer = bufnr })

vim.keymap.set( "n", "<leader>ctt", function () vim.cmd.RustLsp('testables') end, { silent = true, buffer = bufnr, desc = "run all tests" })
vim.keymap.set( "n", "<leader>ctl", function () vim.cmd.RustLsp { 'testables', bang = true } end, { silent = true, buffer = bufnr, desc = "run last tests" })
vim.keymap.set( "n", "<leader>ctr", function () vim.cmd.RustLsp('relatedTests') end, { silent = true, buffer = bufnr, desc = "related tests" })
vim.keymap.set( "n", "gr", function () vim.cmd.RustLsp('run') end, { silent = true, buffer = bufnr, desc = "run under cursor" })

vim.keymap.set( "n", "<leader>cdr", function () vim.cmd.RustLsp('relatedDiagnostics') end, { silent = true, buffer = bufnr, desc = "related diagnostics" })
vim.keymap.set( "n", "<leader>cds", function () vim.cmd.RustLsp('renderDiagnostics') end, { silent = true, buffer = bufnr, desc = "show diagnostics" })

vim.keymap.set( "n", "<leader>co", function () vim.cmd.RustLsp('openDocs') end, { silent = true, buffer = bufnr, desc = "docs.rs" })
vim.keymap.set( "n", "J", function () vim.cmd.RustLsp('joinLines') end, { silent = true, buffer = bufnr, desc = "Join Lines" })
