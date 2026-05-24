---@type vim.lsp.Config
return {
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
}
