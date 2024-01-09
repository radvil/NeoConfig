---@diagnostic disable: missing-fields, duplicate-set-field
return {
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

  ---@type notify.Config
  opts = {
    background_colour = "NotifyBackground",
    -- stylua: ignore start
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.36) end,
    -- stylua: ignore end

    ---@type "default" | "minimal" | "simple" | "compact" | "wrapped-compact"
    render = "default",
    ---@type "fade_in_slide_out" | "fade" | "slide" | "static"
    stages = "fade",
    timeout = 1000,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = "",
    },

    --custom config
    banned_messages = {},
  },

  config = function(_, opts)
    require("notify").setup(opts)
    vim.api.nvim_set_hl(0, "NotifyBackground", {
      background = "#000000",
      blend = 0,
    })
  end,

  init = function()
    local Util = require("neoverse.utils")
    if not Util.lazy_has("noice.nvim") then
      local origin = vim.notify
      Util.on_very_lazy(function()
        vim.notify = function(msg, ...)
          if vim.list_contains(Util.opts("nvim-notify").banned_messages, msg) then
            return origin(msg, ...)
          else
            return require("notify")(msg, ...)
          end
        end
      end)
    end
  end,
}
