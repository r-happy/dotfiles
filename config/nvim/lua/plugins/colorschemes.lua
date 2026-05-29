local tawny = require("config.tawny")

return {
  {
    "r-happy/tawny.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      bold = true,
      variant = tawny.variant,
    },
  },
}
