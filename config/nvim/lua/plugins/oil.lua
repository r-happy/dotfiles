return {
    {
        'stevearc/oil.nvim',
        event = { "VimEnter" },
        opts = {
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true
            },
        },
    }
}
