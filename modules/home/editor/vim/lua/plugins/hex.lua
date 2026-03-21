return {
  'RaafatTurki/hex.nvim',
  cmd = { 'HexToggle', 'HexDump', 'HexAssemble' },
  event = { 'CmdwinEnter', 'CmdlineEnter' },
  keys = {
    { "<leader>fh", function () require 'hex'.toggle() end, desc = "Hex View Toggle" },
  }
}
