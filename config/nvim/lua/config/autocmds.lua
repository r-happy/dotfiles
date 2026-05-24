local folds_group = vim.api.nvim_create_augroup("dotfiles-folds", { clear = true })

local function reset_folds(bufnr)
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.wo[win].foldmethod = "manual"
    vim.wo[win].foldexpr = "0"
    vim.wo[win].foldenable = false
    vim.wo[win].foldlevel = 99
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = folds_group,
  callback = function(args)
    reset_folds(args.buf)
  end,
})
