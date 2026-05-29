local M = {}

local source_path = debug.getinfo(1, "S").source:sub(2)
local real_source_path = vim.loop.fs_realpath(source_path) or source_path
local repo_root = vim.fn.fnamemodify(real_source_path, ":h:h:h:h")
local variant_path = repo_root .. "/nix/lib/tawny-variant.nix"

local ok, lines = pcall(vim.fn.readfile, variant_path)
local variant = "dark"

if ok and #lines > 0 then
  local value = lines[1]:match([["([%a]+)"]]) or lines[1]:match("([%a]+)")
  if value == "light" or value == "dark" then
    variant = value
  end
end

M.variant = variant

return M
