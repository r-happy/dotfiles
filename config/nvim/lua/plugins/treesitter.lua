return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      local languages = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vimdoc",
        "yaml",
      }

      ts.setup()
      ts.install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles-treesitter", { clear = true }),
        pattern = {
          "c",
          "cpp",
          "css",
          "dockerfile",
          "go",
          "gomod",
          "gosum",
          "help",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "query",
          "rust",
          "sh",
          "toml",
          "typescript",
          "typescriptreact",
          "yaml",
        },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
        end,
      })
    end,
  },
}
