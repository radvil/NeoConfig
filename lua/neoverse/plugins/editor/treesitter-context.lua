---@type LazySpec
local M = {}
M[1] = "nvim-treesitter/nvim-treesitter-context"
M.dependencies = "nvim-treesitter/nvim-treesitter"
M.enabled = false
M.event = "VeryLazy"
M.opts = {
  enable = true,
  throttle = true,
  max_lines = 0,
  patterns = {
    default = {
      "class",
      "function",
      "method",
    },
  },
}
return M
