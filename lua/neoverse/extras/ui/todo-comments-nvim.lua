---@type LazySpec
return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  enabled = true,
  config = true,
  -- stylua: ignore start
  keys = {
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
  },
}
