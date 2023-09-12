return {
  "loctvl842/monokai-pro.nvim",
  priority = 999,
  lazy = false,
  config = function(_, opts)
    local Config = require("neoverse.config")
    local NeoDefaults = {
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
          ZenBg = { bg = Config.palette.bg },
          Visual = {
            bg = "#55435b",
          },
          TelescopeSelectionCaret = {
            link = "Visual",
          },
          TelescopeMatching = {
            fg = Config.palette.yellow,
          },
          FlashCurrent = {
            fg = Config.palette.bg,
            bg = Config.palette.yellow,
            bold = true,
          },
          FlashMatch = {
            fg = Config.palette.bg2,
            bg = Config.palette.blue2,
          },
          FlashLabel = {
            fg = Config.palette.fg,
            bg = Config.palette.pink,
            bold = true,
          },
        }
      end,
    }

    opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})

    if Config.transparent then
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

    require("monokai-pro").setup(opts)
  end,
}
