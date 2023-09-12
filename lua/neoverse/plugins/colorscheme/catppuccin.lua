---@type LazySpec
local M = {}

M[1] = "catppuccin/nvim"
M.name = "catppuccin"
M.priority = 1000
M.lazy = false

M.config = function()
  local Config = require("neoverse.config")
  require("catppuccin").setup({
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
      barbecue = {
        dim_dirname = true,
        bold_basename = false,
        dim_context = true,
        alt_background = false,
      },
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
        custom_bg = Config.transparent and "lualine" or "NONE",
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
    },
    custom_highlights = function()
      return {
        FlashCurrent = {
          fg = Config.palette.bg,
          bg = Config.palette.yellow,
          style = { "bold" },
        },
        FlashMatch = {
          fg = Config.palette.bg2,
          bg = Config.palette.blue2,
        },
        FlashLabel = {
          fg = Config.palette.fg,
          bg = Config.palette.pink,
          style = { "bold" },
        },
        NeoTreeIndentMarker = {
          fg = "#313244",
        },
      }
    end,
  })
end

return M
