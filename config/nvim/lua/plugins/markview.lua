-- For `plugins/markview.lua` users.
return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "quarto", "rmd", "typst" },
    opts = {
      preview = {
        enable = false,
      },
    },
    keys = {
      { "<leader>m", "<cmd>Markview<cr>", desc = "Toggle Markview" },
    },

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },
}
