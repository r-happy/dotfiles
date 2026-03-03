vim.keymap.set(
    'n',
    '<leader>e',
    function() vim.cmd("Oil") end,
    { desc = "Open Oil" }
)

-- snacks
vim.keymap.set(
    'n',
    'sf',
    function() Snacks.picker.smart() end,
    { desc = "picker smart" }
)
vim.keymap.set(
    'n',
    'se',
    function() Snacks.picker.explorer() end,
    { desc = "picker smart" }
)
vim.keymap.set(
    'n',
    'spr',
    function() Snacks.picker.recent() end,
    { desc = "picker recent files" }
)
vim.keymap.set(
    'n',
    'spg',
    function() Snacks.picker.grep() end,
    { desc = "grep files" }
)
vim.keymap.set(
    'n',
    'gd',
    function() Snacks.picker.lsp_definitions() end,
    { desc = "move define" }
)
vim.keymap.set('n', 'spl', function()
    local actions = {
        { "Definitions",     Snacks.picker.lsp_definitions },
        { "Implementations", Snacks.picker.lsp_implementations },
        { "Symbols",         Snacks.picker.lsp_symbols },
        { "References",      Snacks.picker.lsp_references },
        { "Type Definition", Snacks.picker.lsp_type_definitions },
    }

    vim.ui.select(actions, {
        prompt = "LSP Actions:",
        format_item = function(item) return item[1] end,
    }, function(choice)
        if choice then choice[2]() end
    end)
end, { desc = "LSP Action Picker" })

-- flash
vim.keymap.set(
    'n',
    '<Enter>',
    function() require("flash").jump() end,
    { desc = "Flash" }
)

-- lsp
vim.keymap.set(
    'n',
    'K',
    function() vim.lsp.buf.hover() end,
    { desc = "LSP Hover" }
)

-- lazygit
vim.keymap.set(
    "n",
    "sg",
    function() Snacks.lazygit() end,
    { desc = "Snacks: LazyGit" }
)

-- terminal
vim.keymap.set(
    { "n", "t" },
    "<C-\\>",
    function()
        Snacks.terminal.toggle(nil, {
            win = { position = "float" }
        })
    end, { desc = "Snacks: Toggle Main Terminal" }
)

-- markdown
vim.keymap.set('v', '<leader>b', [[:s/\s*\\*$/ \\/ <CR>]], { desc = 'Add MD line breaks' })
