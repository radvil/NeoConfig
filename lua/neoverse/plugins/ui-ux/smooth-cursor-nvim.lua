return {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>ms",
      function()
        if not require("neoverse.state").smooth_cursor then
          vim.cmd("SmoothCursorStart")
          vim.notify("Smooth cursor » enabled", vim.log.levels.INFO)
          require("neoverse.state").smooth_cursor = true
        else
          vim.cmd("SmoothCursorStop")
          vim.notify("Smooth cursor » disabled", vim.log.levels.WARN)
          require("neoverse.state").smooth_cursor = false
        end
      end,
      desc = "Toggle smooth cursor",
      silent = true,
    },
  },
  opts = {
    disabled_filetypes = {
      "DiffviewFiles",
      "NeogitStatus",
      "Dashboard",
      "dashboard",
      "MundoDiff",
      "NvimTree",
      "neo-tree",
      "Outline",
      "prompt",
      "Mundo",
      "alpha",
      "help",
      "dbui",
      "edgy",
      "dirbuf",
      "fugitive",
      "fugitiveblame",
      "gitcommit",
      "Trouble",
      "alpha",
      "help",
      "qf",
    },
    disable_float_win = true,
    autostart = require("neoverse.state").smooth_cursor,
    intervals = 13,
    threshold = 1,
    cursor = "",
    type = "exp",
    speed = 13,
    fancy = {
      enable = true,
      head = {
        cursor = "▷",
        texthl = "SmoothCursor",
        linehl = not require("neoverse.config").transparent and "CursorLine" or nil,
      },
      body = {
        { cursor = "", texthl = "SmoothCursorRed" },
        { cursor = "", texthl = "SmoothCursorOrange" },
        { cursor = "●", texthl = "SmoothCursorYellow" },
        { cursor = "●", texthl = "SmoothCursorGreen" },
        { cursor = "•", texthl = "SmoothCursorAqua" },
        { cursor = ".", texthl = "SmoothCursorBlue" },
        { cursor = ".", texthl = "SmoothCursorPurple" },
      },
      tail = { cursor = nil, texthl = "SmoothCursor" },
    },
  },
}
