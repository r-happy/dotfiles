return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = {
        enabled = false,
        heading = {
            enabled = true,
            sign = false,
            backgrounds = {},
            icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
            position = 'inline',
        }
    },
    keys = {
        {
            '<leader>m',
            '<cmd>RenderMarkdown toggle<cr>',
            desc = 'Toggle Markdown Render',
        },
    },
}
