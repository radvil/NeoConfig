local ft_windows = {
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
}

return {
  "folke/tokyonight.nvim",
  priority = 999,
  lazy = false,
  config = function(_, opts)
    local Config = require("neoverse.config")

    local NeoDefaults = {
      style = "day",
      lualine_bold = true,
      dim_inactive = false,
      sidebars = ft_windows,
      terminal_colors = true,
      hide_inactive_statusline = true,
      transparent = Config.transparent,
      transparent_sidebar = Config.transparent,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
      -- on_colors = function(colors)
      --   if not Config.transparent then
      --     colors.border = "#12131D"
      --   else
      --     colors.border = Config.palette.yellow
      --   end
      -- end,
    }

    if Config.darkmode then
      NeoDefaults.style = "moon"
      NeoDefaults.styles.sidebars = "dark"
      NeoDefaults.styles.floats = "dark"
    end

    if Config.transparent then
      NeoDefaults.styles.sidebars = "transparent"
      NeoDefaults.styles.floats = "transparent"
    end

    opts = vim.tbl_deep_extend("force", NeoDefaults, opts or {})

    require("tokyonight").setup(opts)
  end,
}
