return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = true,
                sections = {
                    {
                        section = "terminal",
                        cmd =
                        "chafa ~/.config/nvim/dog.jpg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
                        height = 17,
                        padding = 1,
                    },
                    {
                        pane = 2,
                        { section = "keys",   gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                },
            },
            explorer = {
                -- enabled = true,
                replace_netrw = true,
            },
            indent = {
                enabled = true,
                indent = {
                    char = "┊",
                    hl = "SnacksIndent",
                },
                scope = {
                    enabled = true,
                    char = "┊",
                    underline = false,
                    only_current = true,
                },
                chunk = { enabled = false },
            },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = {
                enabled = true,
                sources = {
                    explorer = {
                        layout = {
                            preset = "right",
                        },
                        win = {
                            list = {
                                keys = {
                                    ["<BS>"] = "explorer_up",
                                    ["gs"] = function()
                                        Snacks.picker.lsp_symbols()
                                    end,
                                },
                            },
                        },
                    },

                    lsp_symbols = {
                        layout = {
                            preset = "right",
                            preview = true,
                        },
                    },
                },
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            terminal = {
                enabled = true,
                win = {
                    style = "terminal"
                },
            },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                },
            },
        },
    },
}
