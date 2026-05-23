return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local parsers = {
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
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vimdoc",
        "yaml",
      }
      local filetypes = {
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
        "sql",
        "toml",
        "typescript",
        "typescriptreact",
        "yaml",
      }
      local group = vim.api.nvim_create_augroup("dotfiles-treesitter", { clear = true })

      local function reset_folds(bufnr)
        for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
          vim.wo[win].foldmethod = "manual"
          vim.wo[win].foldexpr = "0"
          vim.wo[win].foldenable = false
          vim.wo[win].foldlevel = 99
        end
      end

      ts.setup()
      ts.install(parsers)
      vim.treesitter.foldexpr = function()
        return "0"
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          reset_folds(args.buf)
        end,
      })
    end,
  },
}
