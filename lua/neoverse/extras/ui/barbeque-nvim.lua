return {
  "utilyre/barbecue.nvim",
  event = "BufReadPost",
  name = "barbecue",
  dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>ub",
      function()
        require("barbecue.ui").toggle()
      end,
      desc = "Toggle » Barbeque",
    },
  },
  opts = {
    context_follow_icon_color = false,
    show_basename = false,
  },
}
