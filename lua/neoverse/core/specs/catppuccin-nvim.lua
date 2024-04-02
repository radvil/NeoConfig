local M = {}

M.config = function(_, opts)
  local palette = require("neoverse.config").palette
  local transparent = vim.g.neo_transparent
  ---@type CatppuccinOptions
  local NeoDefaults = {
    ---@type string
    flavour = "auto",
    transparent_background = transparent,
    term_colors = true,
    integrations = {
      treesitter = true,
      lsp_trouble = true,
      cmp = true,
      gitsigns = true,
      which_key = true,
      markdown = true,
      ts_rainbow2 = true,
      neotree = true,
      nvimtree = true,
      harpoon = true,
      headlines = true,
      mason = true,
      illuminate = true,
      navic = {
        enabled = true,
        custom_bg = transparent and "NONE" or "lualine",
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      native_lsp = {
        enabled = true,
        inlay_hints = {
          background = true,
        },
      },
      telescope = {
        enabled = true,
        style = vim.g.neo_winborder == "none" and "nvchad" or "classic",
      },
    },
    custom_highlights = function(colors)
      local hl_groups = {
        Visual = { bg = "#5e4965" },
        Folded = {
          bg = transparent and colors.crust or colors.mantle,
          fg = colors.maroon,
        },
        CursorLine = { bg = colors.surface0 },
        StatusLineNC = { bg = colors.crust },
        StatusLine = {
          bold = false,
          bg = colors.base,
          fg = colors.rosewater,
        },
        IncSearch = { bg = colors.maroon, fg = colors.crust },
        WinSeparator = { fg = colors.surface1 },
        MiniIndentscopeSymbol = { fg = colors.flamingo },
        NavicText = { fg = colors.subtext0, bold = false },
        NavicSeparator = { fg = colors.surface1 },
        FlashCurrent = {
          fg = palette.dark,
          bg = palette.yellow,
          style = { "bold" },
        },
        FlashMatch = { fg = colors.surface0, bg = palette.sky },
        FlashLabel = {
          fg = palette.light,
          bg = palette.pink,
          style = { "bold" },
        },
        NeoTreeIndentMarker = { fg = colors.surface0 },
        NeoTreeGitModified = { fg = colors.rosewater },
        NeoTreeGitUntracked = { fg = colors.peach },
        NeoTreeGitRenamed = { fg = colors.pink },
        NeoTreeTabInactive = { bg = colors.base },
        NeoTreeTabActive = {
          bg = transparent and colors.none or colors.surface0,
          fg = colors.text,
          bold = false,
        },
        NeoTreeTabSeparatorInactive = {
          bg = colors.base,
          fg = colors.base,
        },
        NeoTreeTabSeparatorActive = {
          bg = transparent and colors.none or colors.surface0,
          fg = colors.peach,
        },
        NeoTreeTitlebar = {
          bg = colors.blue,
          fg = colors.crust,
          bold = true,
        },
        NvimTreeIndentMarker = { link = "NeoTreeIndentMarker" },
        NvimTreeGitDirty = { link = "NeoTreeGitModified" },
        NvimTreeWinSeparator = { link = "WinSeparator" },
        SymbolsOffsetFill = {
          bg = colors.blue,
          fg = colors.mantle,
          bold = true,
        },
        SymbolsOutlineConnector = { link = "NeoTreeIndentMarker" },
        GitSignsUntracked = { fg = colors.blue },
        GitSignsTopDelete = { fg = colors.maroon },
        NoicePopupmenuBorder = { fg = colors.peach },
        NoiceCmdlinePopupBorder = { fg = colors.peach },
        NoiceCmdlinePopupTitle = { fg = colors.subtext0 },
        NoiceCmdlineIcon = { fg = colors.subtext0 },
        InclineActive = { bg = colors.surface0, fg = colors.rosewater },
        InclineInActive = { bg = colors.mantle, fg = colors.surface1 },
      }

      if not transparent then
        hl_groups.WinSeparator = { fg = colors.crust }
        hl_groups.NoiceCmdlineIcon = { fg = colors.peach }
      end

      if vim.g.neo_winborder == "none" then
        hl_groups.TelescopePromptBorder = {
          bg = colors.crust,
          fg = colors.crust,
        }
        hl_groups.TelescopePromptNormal = { bg = colors.crust }
        hl_groups.TelescopePromptTitle = {
          bold = true,
          bg = colors.maroon,
          fg = colors.crust,
        }
        hl_groups.TelescopeResultsTitle = {
          -- these should set to invisible
          bg = colors.crust,
          fg = colors.crust,
        }
        hl_groups.TelescopePreviewTitle = {
          bold = true,
          bg = colors.blue,
          fg = colors.crust,
        }
        hl_groups.TelescopeResultsBorder = {
          bg = colors.crust,
          fg = colors.crust,
        }
        hl_groups.TelescopePromptPrefix = { bg = colors.crust }
        hl_groups.TelescopeResultsNormal = { bg = colors.crust }
      end

      return hl_groups
    end,
  }
  opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})
  require("catppuccin").setup(opts)
end

return M
