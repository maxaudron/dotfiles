return {
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>ct", group = "tests" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>u", group = "UI" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "telescope" },
        { "<leader>w", group = "windows" },
        { "<leader>q", group = "QUIT" },
        { "<leader><tab>", group = "tabs" },
      }
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}
