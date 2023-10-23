return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  keys = {
    {
      "<leader>mc",
      ":Colortils picker<cr>",
      desc = "Misc » Pick Color",
    },
  },
  config = function()
    require("colortils").setup()
  end,
}
