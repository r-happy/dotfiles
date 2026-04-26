return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "zapling/mason-conform.nvim",
    },
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          objc = { "clang-format" },
          objcpp = { "clang-format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          htmlangular = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          tex = { "latexindent" },
        },

        formatters = {
          prettier = {
            prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
          },
        },

        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      })

      require("mason-conform").setup({
        ignore_install = {},
      })
    end,
  },
}
