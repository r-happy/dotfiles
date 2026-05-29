local tawny = require("config.tawny")

local options = {
  cursorcolumn = true,
  cursorline = true,
  smarttab = true,
  tabstop = 2,
  autoindent = true,
  smartindent = true,
  copyindent = true,
  shiftwidth = 2,
  shiftround = true,
  expandtab = true,
  number = true,
  relativenumber = true,
  autoread = true,
  wrap = false,
  mouse = "",
  wildmenu = true,
  foldmethod = "manual",
  foldexpr = "0",
  foldenable = false,
  foldlevel = 99,
  foldlevelstart = 99,
  clipboard = "unnamedplus",
  termguicolors = true,
  scrolloff = 10,
  sidescrolloff = 10,
  hidden = true,
  autowriteall = true,
  swapfile = false,
  showcmd = true,
}

for name, value in pairs(options) do
  vim.opt[name] = value
end

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

vim.o.background = tawny.variant
vim.cmd("colorscheme " .. (tawny.variant == "light" and "tawny-light" or "tawny"))

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
