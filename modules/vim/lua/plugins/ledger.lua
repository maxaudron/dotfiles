return {
  'ledger/vim-ledger',
  init = function()
    -- to create global variables accessible to
    -- vimscript we use`vim.g`
    vim.g.ledger_bin = 'hledger'
    vim.g.ledger_extra_options = '--strict ordereddates payees uniqueleafnames'
  end,
}
