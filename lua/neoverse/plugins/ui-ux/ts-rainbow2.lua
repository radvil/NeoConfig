--- @type LazySpec
local M = {}
M[1] = "HiPhish/nvim-ts-rainbow2"
M.event = "BufReadPre"
M.dependencies = "nvim-treesitter"
M.config = function()
  local rainbow = require("ts-rainbow")
  require("nvim-treesitter.configs").setup({
    rainbow = {
      enable = true,
      strategy = rainbow.strategy.global,
      query = {
        "rainbow-parens",
        html = "rainbow-tags",
        latex = "rainbow-blocks",
      },
    },
  })
end
return M
