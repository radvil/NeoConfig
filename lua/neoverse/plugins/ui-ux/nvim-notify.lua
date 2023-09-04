---@type LazySpec
local M = {
  "rcarriga/nvim-notify",
  event = "BufReadPost",

  opts = function(_, opts)
    --opts.render = "minimal"
    opts.merge = true
    opts.replace = true
    opts.timeout = 1000
    opts.max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end
    opts.max_width = function()
      return math.floor(vim.o.columns * 0.36)
    end
    -- TODO: set universal options
    if require("neoverse.config").transparent then
      opts.background_colour = "#000000"
    end
    return opts
  end,

  init = function()
    local util = require("minimal.util")
    if util.has("noice.nvim") then
      util.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    else
      vim.keymap.set("n", "<leader>nd", function()
        require("notify").dismiss({
          pending = true,
          silent = true,
        })
      end, { desc = "Notification » Dismiss" })
    end
  end,
}

return M
