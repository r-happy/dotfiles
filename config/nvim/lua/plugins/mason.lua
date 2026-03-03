-- htmlangularファイルにhtml LSPもアタッチする（補完のみ・フォーマットはprettierに任せる）
vim.lsp.config('html', {
    filetypes = { 'html', 'htmlangular' },
    init_options = {
        provideFormatter = false,
    },
})

return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        keys = { { "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = { "lua_ls", "html" },
            automatic_enable = true,
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    }
}
