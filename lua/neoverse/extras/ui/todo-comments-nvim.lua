---@type LazySpec
return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  opts = {},
  -- stylua: ignore start
  keys = {
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "goto next [t]odo",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "goto previous [t]odo",
    },
    {
      "<leader>xt",
      "<cmd>TodoTrouble<Cr>",
      desc = "todo diagnosti[x] (trouble)",
    },
    {
      "<leader>/t",
      "<cmd>TodoTelescope<Cr>",
      desc = "telescope » [t]asks/[t]odos",
    },
  },
}
