return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        config = function()
            require("nvim-treesitter").install({
                "lua",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",

                "go",
                "gomod",
                "gosum",
                "rust",
                "toml",
                "c",
                "cpp",

                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                "yaml",

                "dockerfile",
                "bash",
            })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { '*' },
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end
    }
}
