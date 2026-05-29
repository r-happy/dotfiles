return {
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local has_hlslens = pcall(require, "hlslens")

      return {
        show = true,
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          search = has_hlslens,
        },
      }
    end,
  },
}
