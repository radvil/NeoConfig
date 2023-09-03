---@type LazySpec
local M = {}
M[1] = "abecodes/tabout.nvim"
M.event = "InsertEnter"
M.dependencies = { "nvim-cmp", "nvim-treesitter" }
M.opts = {
  tabkey = "<a-l>",
  backwards_tabkey = "<a-h>",
}
return M
