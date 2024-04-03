return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      {
        "<leader>cs",
        "<cmd>Outline<cr>",
        desc = "toggle [c]ode [s]ymbols",
      },
    },
    opts = function()
      local Config = require("neoverse.config")
      local defaults = require("outline.config").defaults
      local filter = Config.kind_filter
      local opts = {
        symbols = {
          filter = filter,
          icons = {},
        },
        outline_window = {
          winhl = "Normal:NormalFloat",
        },
      }
      if type(filter) == "table" then
        for kind, symbol in pairs(defaults.symbols.icons) do
          opts.symbols.icons[kind] = {
            icon = Config.icons.Kinds[kind] or symbol.icon,
            hl = symbol.hl,
          }
        end
      end
      return opts
    end,
  },

  -- edgy integration
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      local edgy_idx = Lonard.plugin.extra_idx("ui.edgy")
      local symbols_idx = Lonard.plugin.extra_idx("editor.outline")

      if edgy_idx and edgy_idx > symbols_idx then
        Lonard.warn(
          "The `edgy.nvim` extra must be **imported** before the `outline.nvim` extra to work properly.",
          ---@diagnostic disable-next-line: missing-fields
          { title = "NeoVerse" }
        )
      end

      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Outline",
        ft = "Outline",
        pinned = true,
        open = "Outline",
      })
    end,
  },
}
