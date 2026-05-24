return {
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local lsp = require("config.lsp")

      vim.lsp.config("*", {
        capabilities = lsp.capabilities(),
      })

      lsp.enable_all()
    end,
  },
}
