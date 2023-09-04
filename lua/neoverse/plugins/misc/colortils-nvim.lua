return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  keys = {
    {
      "<leader>mc",
      ":Colortils picker<cr>",
      desc = "Color picker",
    },
  },
  config = function()
    require("colortils").setup()
  end,
}
