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
