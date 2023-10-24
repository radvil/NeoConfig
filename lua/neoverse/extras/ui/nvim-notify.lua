---@type LazySpec
local M = {
  "rcarriga/nvim-notify",
  config = function(_, opts)
    ---@type notify.Config
    local defaults = {
      background_colour = "NotifyBackground",
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
    }

    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    if vim.g.neo_transparent then
      opts.background_colour = "#000000"
    end

    require("notify").setup(opts)
  end,

  init = function()
    local Util = require("neoverse.utils")
    -- when noice is not enabled, install notify on VeryLazy
    if not Util.lazy_has("noice.nvim") then
      Util.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end

    vim.keymap.set("n", "<leader>nd", function()
      require("notify").dismiss({
        pending = true,
        silent = true,
      })
    end, { desc = "Notification » Dismiss" })
  end,
}

return M
