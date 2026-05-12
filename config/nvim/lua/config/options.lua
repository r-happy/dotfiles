-- cursor
vim.opt.cursorcolumn = true
vim.opt.cursorline = true

-- indent
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- number
vim.opt.number = true
vim.opt.relativenumber = true

-- autoread
vim.opt.autoread = true

-- line
vim.opt.wrap = false
vim.opt.wildmenu = true
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "0"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
local function reset_folds(buf)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win].foldmethod = "manual"
    vim.wo[win].foldexpr = "0"
    vim.wo[win].foldenable = false
    vim.wo[win].foldlevel = 99
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("dotfiles-folds", { clear = true }),
  callback = function(args)
    reset_folds(args.buf)
  end,
})

if vim.fn.has("wsl") == 1 then
  vim.ui.open = function(path)
    local scrubbed_path = path:gsub("^file://", "")
    local cmd = "wslpath -w " .. vim.fn.shellescape(scrubbed_path)
    local handle = io.popen(cmd)
    local win_path = handle:read("*a"):gsub("%s+$", "")
    handle:close()

    if win_path ~= "" then
      vim.fn.jobstart({ "explorer.exe", win_path })
    end
  end
end

-- vim.g.clipboard = {
--   name = 'wl-clipboard',
--   copy = {
--     ["+"] = 'wl-copy',
--     ["*"] = 'wl-copy',
--   },
--   paste = {
--     ["+"] = 'wl-paste',
--     ["*"] = 'wl-paste',
--   },
--   cache_enabled = 0,
-- }
--
vim.opt.clipboard = "unnamedplus"

-- color
vim.opt.termguicolors = true

-- scroll
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- buffer
vim.opt.hidden = true
vim.opt.autowriteall = true
vim.opt.swapfile = false

-- cmd
vim.opt.showcmd = true

-- color
vim.cmd("colorscheme tawny")

-- plugins
local disabled_builtins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in ipairs(disabled_builtins) do
  vim.g["loaded_" .. plugin] = 1
end
