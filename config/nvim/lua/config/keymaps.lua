local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("n", "<leader>e", "<cmd>Oil<cr>", "Open Oil")
map("n", "sf", function() Snacks.picker.files() end, "picker file")
map("n", "sm", function() Snacks.picker.smart() end, "picker smart")
map("n", "se", function() Snacks.picker.explorer() end, "picker explorer")
map("n", "spr", function() Snacks.picker.recent() end, "picker recent files")
map("n", "spg", function() Snacks.picker.grep() end, "grep files")
map("n", "spc", function() Snacks.picker.commands() end, "picker commands")
map("n", "sph", function() Snacks.picker.command_history() end, "picker command history")
map("n", "gd", function() Snacks.picker.lsp_definitions() end, "move define")

map("n", "spl", function()
  local actions = {
    { "Definitions", Snacks.picker.lsp_definitions },
    { "Implementations", Snacks.picker.lsp_implementations },
    { "Symbols", Snacks.picker.lsp_symbols },
    { "References", Snacks.picker.lsp_references },
    { "Type Definition", Snacks.picker.lsp_type_definitions },
  }

  vim.ui.select(actions, {
    prompt = "LSP Actions:",
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if choice then
      choice[2]()
    end
  end)
end, "LSP Action Picker")

map("n", "<Enter>", function() require("flash").jump() end, "Flash")
map("n", "K", function() vim.lsp.buf.hover() end, "LSP Hover")
map("n", "sg", function() Snacks.lazygit() end, "Snacks: LazyGit")

local toggle_terminal = function()
  Snacks.terminal.toggle(nil, {
    win = { position = "bottom" },
  })
end

map({ "n", "t" }, "<C-\\>", toggle_terminal, "Snacks: Toggle Main Terminal")
map({ "n", "t" }, "<C-¥>", toggle_terminal, "Snacks: Toggle Main Terminal")
map({ "n", "t" }, "<C-@>", toggle_terminal, "Snacks: Toggle Main Terminal")
map({ "n", "t" }, "<Nul>", toggle_terminal, "Snacks: Toggle Main Terminal")
map("v", "<leader>b", [[:s/\s*\\*$/ \\/ <CR>]], "Add MD line breaks")
