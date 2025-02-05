---@diagnostic disable: missing-fields, duplicate-set-field
return {
  {
    "telescope.nvim",
    optional = true,
    dependencies = { "rcarriga/nvim-notify" },
  },

  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "ZN",
        function()
          require("notify").dismiss({ pending = true, silent = true })
        end,
        desc = "quit/dismiss [N]otifications",
      },
      {
        "<leader>/N",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "telescope » [N]otifications",
      },
    },
    ---@type notify.Config
    opts = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      background_colour = function()
        return vim.g.neo_transparent and "#00000000" or "#000000"
      end,
      -- stylua: ignore start
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.36) end,
      -- stylua: ignore end
      ---@type "default" | "minimal" | "simple" | "compact" | "wrapped-compact"
      render = "default",
      ---@type "fade_in_slide_out" | "fade" | "slide" | "static"
      stages = "static",
      timeout = 1000,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
    },
    init = function()
      Lonard.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end,
  },
}
