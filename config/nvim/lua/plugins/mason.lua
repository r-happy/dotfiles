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
            ensure_installed = {
                "basedpyright",
                "clangd",
                "gopls",
                "html",
                "lua_ls",
                "nil_ls",
                "ruff",
                "rust_analyzer",
            },
            automatic_enable = true,
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    }
}
