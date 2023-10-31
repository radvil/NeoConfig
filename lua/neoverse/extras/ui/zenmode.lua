return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",

  keys = {
    {
      "<Leader>wz",
      ":ZenMode<cr>",
      desc = "window » zen mode toggle",
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
