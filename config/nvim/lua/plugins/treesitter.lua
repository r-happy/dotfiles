return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
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
      vim.treesitter.foldexpr = function()
        return "0"
      end

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
          local function reset_folds()
            for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
              vim.wo[win].foldmethod = "manual"
              vim.wo[win].foldexpr = "0"
              vim.wo[win].foldenable = false
              vim.wo[win].foldlevel = 99
            end
          end

          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          reset_folds()
        end,
      })
    end,
  },
}
