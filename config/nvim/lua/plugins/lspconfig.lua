return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    init = function()
      if vim.fn.exists(":LspInfo") == 0 then
        vim.api.nvim_create_user_command("LspInfo", function()
          vim.cmd("checkhealth vim.lsp")
        end, { desc = "Alias to :checkhealth vim.lsp" })
      end
    end,
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        "basedpyright",
        "clangd",
        "gopls",
        "html",
        "lua_ls",
        "nil_ls",
        "ruff",
        "sqls",
        "ts_ls",
      }

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              buildScripts = { enable = true },
              sysrootSrc = vim.env.RUST_SRC_PATH,
            },
            procMacro = { enable = true },
            check = { command = "clippy" },
          },
        },
      })

      vim.lsp.enable(servers)
      vim.lsp.enable("rust_analyzer")
    end,
  },
}
