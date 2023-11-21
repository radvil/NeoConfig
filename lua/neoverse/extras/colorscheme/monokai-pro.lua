return {
  "loctvl842/monokai-pro.nvim",
  priority = 999,
  lazy = false,
  config = function(_, opts)
    local Config = require("neoverse.config")
    local NeoDefaults = {
      ---@type "classic" | "octagon" | "pro" | "machine" | "ristretto" | "spectrum"
      filter = "octagon",
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
          ZenBg = { bg = Config.palette.dark },
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
            fg = Config.palette.dark,
            bg = Config.palette.yellow,
            bold = true,
          },
          FlashMatch = {
            fg = Config.palette.dark2,
            bg = Config.palette.sky,
          },
          FlashLabel = {
            fg = Config.palette.light,
            bg = Config.palette.pink2,
            bold = true,
          },
        }
      end,
    }

    opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})

    if vim.g.neo_transparent then
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
