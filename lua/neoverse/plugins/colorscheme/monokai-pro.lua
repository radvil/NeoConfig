return {
  "loctvl842/monokai-pro.nvim",
  priority = 999,
  lazy = false,
  opts = function()
    local config = require("neoverse.config")
    local opts = {
      ---@type "classic" | "octagon" | "pro" | "machine" | "ristretto" | "spectrum"
      filter = "pro",
      inc_search = "background",
      terminal_colors = true,
      devicons = true,
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
          underline_fill = false,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro",
          context_start_underline = false,
        },
      },
      override = function()
        return {
          LazyNormal = { link = "Normal" },
          LspInlayHint = { link = "Comment" },
          ZenBg = { bg = config.palette.bg },
          Visual = {
            bg = "#55435b",
          },
          TelescopeSelectionCaret = {
            link = "Visual",
          },
          TelescopeMatching = {
            fg = config.palette.yellow,
          },
          FlashCurrent = {
            fg = config.palette.bg,
            bg = config.palette.yellow,
            bold = true,
          },
          FlashMatch = {
            fg = config.palette.bg2,
            bg = config.palette.blue2,
          },
          FlashLabel = {
            fg = config.palette.fg,
            bg = config.palette.pink,
            bold = true,
          },
        }
      end,
    }

    if config.transparent then
      opts.transparent_background = true
      opts.background_clear = {
        "toggleterm",
        "float_win",
        "telescope",
        "which-key",
        "telescope",
        "neo-tree",
        "renamer",
        "notify",
        "mason",
        "cmp_menu",
        "lsp_info",
        "noice",
      }
    end

    return opts
  end,
}
