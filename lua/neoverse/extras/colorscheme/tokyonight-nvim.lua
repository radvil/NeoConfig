return {
  "folke/tokyonight.nvim",
  priority = 9999,
  lazy = false,
  config = function(_, opts)
    local transparent = vim.g.neo_transparent
    local NeoDefaults = {
      style = "moon",
      lualine_bold = true,
      dim_inactive = false,
      terminal_colors = true,
      transparent = transparent,
      hide_inactive_statusline = true,
      transparent_sidebar = transparent,
      sidebars = {
        "DiffviewFiles",
        "fugitiveblame",
        "NeogitStatus",
        "Dashboard",
        "dashboard",
        "gitcommit",
        "MundoDiff",
        "fugitive",
        "NvimTree",
        "neo-tree",
        "Outline",
        "Trouble",
        "dirbuf",
        "prompt",
        "alpha",
        "Mundo",
        "help",
        "edgy",
        "dbui",
        "qf",
      },
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_colors = function(colors)
        colors.bg_darker = "#0d0e18"
      end,
      on_highlights = function(hl, c)
        hl.Folded = {
          bg = c.bg_dark,
        }
        hl.StatusLineNC = {
          bg = c.bg_dark,
        }
        hl.WinSeparator = {
          fg = transparent and c.fg_gutter or c.bg_darker,
        }
        hl.NeoTreeTabInactive = {
          bg = c.bg_highlight,
          fg = c.fg_dark,
        }
        hl.NeoTreeTabActive = {
          bg = transparent and c.none or c.bg_dark,
          fg = c.blue,
        }
        hl.NeoTreeTabSeparatorInactive = {
          bg = c.bg_highlight,
          fg = c.bg_dark,
        }
        hl.NeoTreeTabSeparatorActive = {
          bg = transparent and c.none or c.bg_dark,
          fg = c.blue,
        }

        if not transparent then
          hl.StatusLine = {
            bg = c.bg_dark,
            fg = c.blue,
          }
          hl.TelescopePromptBorder = {
            bg = c.bg_dark,
            fg = c.bg_dark,
          }
          hl.TelescopePromptNormal = {
            bg = c.bg_dark,
          }
          hl.TelescopePromptTitle = {
            bold = true,
            bg = c.blue1,
            fg = c.bg_dark,
          }
          hl.TelescopePromptPrefix = {
            bg = c.bg_dark,
          }
          hl.TelescopeResultsTitle = {
            bg = c.purple,
          }
          hl.TelescopeResultsNormal = {
            bg = c.bg_dark,
          }
          hl.TelescopeResultsBorder = {
            bg = c.bg_dark,
            fg = c.bg_dark,
          }
        end
      end,
    }
    opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})
    require("tokyonight").setup(opts)
  end,
}
