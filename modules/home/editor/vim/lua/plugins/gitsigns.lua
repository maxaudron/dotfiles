return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = "Stage Hunk" })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "Reset Hunk" })

      map('v', '<leader>gs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "Stage Hunk" })

      map('v', '<leader>gr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "Reset Hunk" })

      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "Stage Buffer" })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Reset Buffer" })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "Preview Hunk" })
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

      map('n', '<leader>gb', function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame" })

      map('n', '<leader>gd', gitsigns.diffthis, { desc = "Diff" })

      map('n', '<leader>gD', function()
        gitsigns.diffthis('~')
      end, { desc = "Diff" })

      map('n', '<leader>gQ', function() gitsigns.setqflist('all') end)
      map('n', '<leader>gq', gitsigns.setqflist)

      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle Blame" })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Toggle Diff" })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end
  }
}
