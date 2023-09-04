---@type LazySpec
return {
  "glepnir/dashboard-nvim",
  event = "VeryLazy",
  opts = {
    theme = "hyper",
    shortcut_type = "number",
    config = {
      disable_move = true,
      week_header = { enable = true },
      project = { enable = false, limit = 8 },
      packages = { enable = false },
      mru = {
        enable = true,
        limit = 10,
        icon = "📁 ",
        label = "Most recent used",
      },
      shortcut = {
        {
          icon = "📎 ",
          desc = "Plugins",
          group = "@constructor",
          action = [[Lazy]],
          key = "p",
        },
        {
          icon = "🕗 ",
          desc = "Resume",
          group = "DiagnosticWarn",
          action = [[lua require('persistence').load()]],
          key = "s",
        },
        {
          icon = "🔭 ",
          desc = "Files",
          group = "DiagnosticOk",
          action = [[Telescope find_files]],
          key = "f",
        },
        {
          icon = "🔎 ",
          desc = "Grep",
          group = "DiagnosticHint",
          action = [[Telescope live_grep]],
          key = "w",
        },
        {
          icon = "🔧 ",
          desc = "Dotfiles",
          group = "@float",
          action = [[Dotfiles]],
          key = ".",
        },
        {
          icon = "⭕ ",
          desc = "Quit",
          group = "@tag.tsx",
          action = [[qa]],
          key = "q",
        },
      },
    },
  },
}
