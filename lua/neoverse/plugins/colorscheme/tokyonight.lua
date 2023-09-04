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
  opts = function()
    local config = require("neoverse.config")
    local variant = not config.darkmode and "day" or "moon"
    local opts = {
      style = variant,
      terminal_colors = true,
      transparent = config.transparent,
      hide_inactive_statusline = true,
      transparent_sidebar = config.transparent,
      dim_inactive = false,
      lualine_bold = true,
      sidebars = ft_windows,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        if not config.transparent then
          colors.border = "#12131D"
        else
          colors.border = config.palette.yellow
        end
      end,
    }

    if config.transparent then
      opts.styles.sidebars = "transparent"
      opts.styles.floats = "transparent"
    end
    return opts
  end,
}
