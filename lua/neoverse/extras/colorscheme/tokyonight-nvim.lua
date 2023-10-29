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
      hide_inactive_statusline = true,
      transparent = transparent,
      transparent_sidebar = transparent,
      sidebars = {
        "NeogitStatus",
        "prompt",
        "Dashboard",
        "dashboard",
        "alpha",
        "help",
        "dbui",
        "DiffviewFiles",
        "Mundo",
        "MundoDiff",
        "NvimTree",
        "neo-tree",
        "Outline",
        "edgy",
        "dirbuf",
        "qf",
        "fugitive",
        "fugitiveblame",
        "gitcommit",
        "Trouble",
      },
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
    }
    opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})
    require("tokyonight").setup(opts)
  end,
}
