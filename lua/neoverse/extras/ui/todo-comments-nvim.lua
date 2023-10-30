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
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "todo » next reference",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "todo » prev reference",
    },
    {
      "<leader>xt",
      "<cmd>TodoTrouble<Cr>",
      desc = "diagnostics » todo comments [trouble]",
    },
    {
      "<leader>/t",
      "<cmd>TodoTelescope<Cr>",
      desc = "telescope » find tasks [trouble]",
    },
  },
}
