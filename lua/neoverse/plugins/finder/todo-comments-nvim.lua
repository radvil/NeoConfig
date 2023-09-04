---@type LazySpec
local M = {}

M[1] = "folke/todo-comments.nvim"
M.cmd = { "TodoTrouble", "TodoTelescope" }
M.event = "BufReadPost"
M.enabled = true
M.config = true

-- stylua: ignore
M.keys = {
  {
    "]x",
    function() require("todo-comments").jump_next() end,
    desc = "TODO » Next ref",
  },
  {
    "[x",
    function() require("todo-comments").jump_prev() end,
    desc = "TODO » Prev ref",
  },
  {
    "<leader>xt",
    ":TodoTrouble<Cr>",
    desc = "Diagnostics » Todo comments",
  },
  {
    "<leader>/t",
    ":TodoTelescope<Cr>",
    desc = "Telescope » Find tasks",
  },
}

return M
