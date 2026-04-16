return {
  "nvim-mini/mini.icons",
  version = false,
  lazy = true,
  opts = {},
  init = function()
    package.preload["nvim-web-devicons"] = function()
      local mini_icons = require("mini.icons")
      mini_icons.mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = function(_, opts)
    local mini_icons = require("mini.icons")
    mini_icons.setup(opts)
    mini_icons.mock_nvim_web_devicons()
  end,
}
