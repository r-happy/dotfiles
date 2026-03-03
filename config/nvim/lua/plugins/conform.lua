return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "zapling/mason-conform.nvim",
        },
        opts = {},
        config = function()
            require("mason-conform").setup({
                ignore_install = {},
            })

            require("conform").setup({
                formatters_by_ft = {
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    htmlangular = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    graphql = { "prettier" },
                    tex = { "latexindent" },
                },

                formatters = {
                    prettier = {
                        prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                    },
                },

                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
            })
        end,
    },
}
