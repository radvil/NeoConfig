return {
  "loctvl842/monokai-pro.nvim",
  priority = 999,
  lazy = false,
  config = function(_, opts)
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
      override = function(c)
        local colors = {
          none = "NONE",
          base = c.base.background,
          surface1 = "#45475a",
          surface0 = "#313244",
          rosewater = "#f5e0dc",
          peach = c.base.blue,
        }
        return {
          Visual = { bg = "#363b54" },
          ZenBg = { bg = c.base.dark },
          Folded = { bg = c.base.black },
          LazyNormal = { link = "Normal" },
          LspInlayHint = { link = "Comment" },
          IblIndent = { fg = colors.surface1 },
          FlashCurrent = {
            fg = c.base.black,
            bg = c.base.yellow,
            bold = true,
          },
          FlashMatch = {
            fg = c.base.black,
            bg = c.base.cyan,
          },
          FlashLabel = {
            fg = c.base.white,
            bg = c.base.red,
            bold = true,
          },
          NeoTreeGitModified = { fg = colors.rosewater },
          NeoTreeGitUntracked = { fg = colors.peach },
          NeoTreeGitRenamed = { fg = c.base.yellow },
          NeoTreeTabInactive = { bg = colors.base },
          NeoTreeTabActive = {
            bg = colors.surface0,
            fg = colors.text,
            bold = false,
          },
          NeoTreeTabSeparatorInactive = {
            bg = colors.base,
            fg = colors.base,
          },
          NeoTreeTabSeparatorActive = {
            bg = colors.surface0,
            fg = colors.peach,
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
        "NvimTree",
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
