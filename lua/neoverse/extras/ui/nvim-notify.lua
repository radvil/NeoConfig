---@type LazySpec
local M = {
  "rcarriga/nvim-notify",

  keys = {
    {
      "<leader>uN",
      function()
        require("notify").dismiss({ pending = true, silent = true })
      end,
      desc = "Notification » Dismiss",
    },
  },

  config = function()
    ---@type notify.Config
    require("notify").setup({
      background_colour = vim.g.neo_transparent and "#000000" or "NotifyBackground",
      render = "default",
      timeout = 1000,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.36)
      end,
    })
  end,

  init = function()
    local Util = require("neoverse.utils")
    -- when noice is not enabled, install notify on VeryLazy
    if not Util.lazy_has("noice.nvim") then
      Util.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end
  end,
}

return M
