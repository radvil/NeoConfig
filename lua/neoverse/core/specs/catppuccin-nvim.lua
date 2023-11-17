local M = {}

M.config = function(_, opts)
  local palette = require("neoverse.config").palette
  local transparent = vim.g.neo_transparent
  ---@type CatppuccinOptions
  opts = vim.tbl_deep_extend("force", opts or {}, {
    ---@type string
    flavour = "mocha",
    transparent_background = transparent,
    term_colors = true,
    dim_inactive = {
      enabled = false,
      percentage = 0.13,
      shade = "dark",
    },
    integrations = {
      alpha = true,
      barbar = false,
      treesitter = true,
      dropbar = false,
      lsp_trouble = true,
      cmp = true,
      gitsigns = true,
      which_key = true,
      markdown = true,
      ts_rainbow2 = true,
      notify = true,
      mini = true,
      noice = true,
      neotree = true,
      nvimtree = false,
      harpoon = true,
      headlines = true,
      mason = true,
      illuminate = true,
      flash = false,
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
        style = "nvchad",
      },
      barbecue = {
        dim_dirname = true,
        bold_basename = false,
        dim_context = true,
        alt_background = false,
      },
    },
    color_overrides = {
      mocha = {
        surface0 = palette.dark2,
      },
    },
    custom_highlights = function(colors)
      local hls = {
        Folded = {
          bg = transparent and colors.crust or colors.mantle,
        },
        CursorLine = {
          bg = colors.surface0,
        },
        StatusLineNC = {
          bg = colors.crust,
        },
        StatusLine = {
          bold = true,
          bg = colors.base,
          fg = colors.rosewater,
        },
        IncSearch = {
          bg = colors.maroon,
          fg = colors.crust,
        },
        WinSeparator = {
          fg = colors.surface1,
        },
        MiniIndentscopeSymbol = {
          fg = colors.flamingo,
        },
        NavicText = {
          fg = colors.subtext0,
          bold = false,
        },
        NavicSeparator = {
          fg = colors.surface1,
        },
        FlashCurrent = {
          fg = palette.dark,
          bg = palette.yellow,
          style = { "bold" },
        },
        FlashMatch = {
          fg = colors.surface0,
          bg = palette.sky,
        },
        FlashLabel = {
          fg = palette.light,
          bg = palette.pink,
          style = { "bold" },
        },
        NeoTreeIndentMarker = {
          fg = colors.surface0,
        },
        NeoTreeGitModified = {
          fg = colors.rosewater,
        },
        NeoTreeGitUntracked = {
          fg = colors.peach,
        },
        NeoTreeGitRenamed = {
          fg = colors.pink,
        },
        NeoTreeTabInactive = {
          bg = colors.base,
        },
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
        SymbolsOffsetFill = {
          bg = colors.blue,
          fg = colors.mantle,
          bold = true,
        },
        SymbolsOutlineConnector = {
          link = "NeoTreeIndentMarker",
        },
        GitSignsUntracked = {
          fg = colors.blue,
        },
        GitSignsTopDelete = {
          fg = colors.maroon,
        },
        NoicePopupmenuBorder = {
          fg = colors.peach,
        },
        NoiceCmdlinePopupBorder = {
          fg = colors.peach,
        },
        NoiceCmdlinePopupTitle = {
          fg = colors.subtext0,
        },
        NoiceCmdlineIcon = {
          fg = colors.subtext0,
        },
        InclineActive = {
          bg = colors.surface0,
          fg = colors.rosewater,
        },
        InclineInActive = {
          bg = colors.mantle,
          fg = colors.surface1,
        },
      }
      if not transparent then
        hls.WinSeparator = {
          fg = colors.crust,
        }
        hls.TelescopePromptBorder = {
          bg = colors.crust,
          fg = colors.crust,
        }
        hls.TelescopePromptNormal = {
          bg = colors.crust,
        }
        hls.TelescopePromptTitle = {
          bold = true,
          bg = colors.peach,
          fg = colors.crust,
        }
        hls.TelescopePromptPrefix = {
          bg = colors.crust,
        }
        hls.TelescopeResultsTitle = {
          bg = colors.yellow,
        }
        hls.TelescopeResultsNormal = {
          bg = colors.crust,
        }
        hls.TelescopeResultsBorder = {
          bg = colors.crust,
          fg = colors.crust,
        }
        hls.NoiceCmdlineIcon = {
          fg = colors.peach,
        }
      end
      return hls
    end,
  })
  require("catppuccin").setup(opts)
end

return M
