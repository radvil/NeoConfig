return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    local Config = require("neoverse.config")
    ---@type CatppuccinOptions
    opts = vim.tbl_deep_extend("force", opts or {}, {
      ---@type string
      flavour = vim.g.neovide and "macchiato" or "mocha",
      transparent_background = Config.transparent,
      term_colors = true,
      dim_inactive = {
        enabled = not Config.transparent,
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
        mason = true,
        illuminate = true,
        navic = {
          enabled = true,
          custom_bg = Config.transparent and "NONE" or "lualine",
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
          surface0 = Config.palette.dark2,
        },
      },
      custom_highlights = function(colors)
        local hls = {
          CursorLine = {
            bg = colors.surface0,
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
            fg = colors.rosewater,
          },
          FlashCurrent = {
            fg = Config.palette.dark,
            bg = Config.palette.yellow,
            style = { "bold" },
          },
          FlashMatch = {
            fg = colors.surface0,
            bg = Config.palette.sky,
          },
          FlashLabel = {
            fg = Config.palette.light,
            bg = Config.palette.pink2,
            style = { "bold" },
          },
          NeoTreeIndentMarker = {
            fg = colors.surface0,
          },
          NeoTreeGitModified = {
            fg = colors.rosewater,
          },
          NeoTreeTabInactive = {
            bg = colors.mantle,
          },
          NeoTreeTabActive = {
            bg = Config.transparent and colors.none or colors.surface0,
            fg = colors.text,
          },
          NeoTreeTabSeparatorInactive = {
            bg = colors.mantle,
            fg = colors.surface0,
          },
          NeoTreeTabSeparatorActive = {
            bg = Config.transparent and colors.none or colors.surface0,
            fg = colors.peach,
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
        }

        if not Config.transparent then
          hls.WinSeparator = {
            fg = colors.crust,
          }
          hls.StatusLineNC = {
            bg = colors.crust,
          }
          hls.StatusLine = {
            bg = colors.crust,
            fg = colors.rosewater,
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
          hls.Folded = {
            bg = colors.mantle,
          }
        end

        return hls
      end,
    })
    require("catppuccin").setup(opts)
  end,
}
