---@type LazySpec
local M = {}

M[1] = "catppuccin/nvim"
M.name = "catppuccin"
M.priority = 1000
M.lazy = false

M.config = function()
  local config = require("neoverse.config")
  require("catppuccin").setup({
    ---@type string
    flavour = vim.g.neovide and "macchiato" or "mocha",
    transparent_background = config.transparent,
    term_colors = true,
    dim_inactive = {
      enabled = not config.transparent,
      percentage = 0.13,
      shade = "dark",
    },
    integrations = {
      alpha = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = false,
        dim_context = true,
        alt_background = true,
      },
      treesitter = true,
      dropbar = false,
      lsp_trouble = true,
      cmp = true,
      gitsigns = true,
      which_key = true,
      markdown = true,
      ts_rainbow2 = false,
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
        custom_bg = "lualine",
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
          fg = config.palette.bg,
          bg = config.palette.yellow,
          style = { "bold" },
        },
        FlashMatch = {
          fg = config.palette.bg2,
          bg = config.palette.blue2,
        },
        FlashLabel = {
          fg = config.palette.fg,
          bg = config.palette.pink,
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
