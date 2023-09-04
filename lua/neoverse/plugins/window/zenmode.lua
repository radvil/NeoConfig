return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",

  keys = {
    {
      "<a-q>",
      ":ZenMode<cr>",
      desc = "Window » Zen toggle",
    },
    {
      "<Leader>wz",
      ":ZenMode<cr>",
      desc = "Window » Zen toggle",
    },
  },

  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      height = 1,
      options = {
        foldcolumn = "0",
        list = true, -- disable whitespace chars
      },
    },
  },
}
