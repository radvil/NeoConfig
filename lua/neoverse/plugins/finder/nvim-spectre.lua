return {
  "nvim-pack/nvim-spectre",
  config = true,
  keys = {
    {
      "<Leader>fr",
      function()
        require("spectre").open()
      end,
      desc = "Find and replace word",
    },
  },
}
