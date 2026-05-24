local M = {}

M.servers = {
  "basedpyright",
  "clangd",
  "gopls",
  "html",
  "lua_ls",
  "nil_ls",
  "ruff",
  "rust_analyzer",
  "sqls",
  "ts_ls",
}

function M.capabilities()
  return require("blink.cmp").get_lsp_capabilities()
end

function M.enable_all()
  for _, server in ipairs(M.servers) do
    vim.lsp.enable(server)
  end
end

return M
