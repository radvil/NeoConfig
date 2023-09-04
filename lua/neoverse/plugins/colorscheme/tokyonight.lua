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
    local opts = {
      style = "day",
      lualine_bold = true,
      dim_inactive = false,
      sidebars = ft_windows,
      terminal_colors = true,
      hide_inactive_statusline = true,
      transparent = config.transparent,
      transparent_sidebar = config.transparent,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
      on_colors = function(colors)
        if not config.transparent then
          colors.border = "#12131D"
        else
          colors.border = config.palette.yellow
        end
      end,
    }

    if config.darkmode then
      opts.style = "moon"
      opts.styles.sidebars = "dark"
      opts.styles.floats = "dark"
    end

    if config.transparent then
      opts.styles.sidebars = "transparent"
      opts.styles.floats = "transparent"
    end

    return opts
  end,
}
