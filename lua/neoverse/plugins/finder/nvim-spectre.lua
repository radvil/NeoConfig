return {
  "windwp/nvim-spectre",
  config = true,
  keys = {
    {
      "<Leader>sr",
      function()
        require("spectre").open()
      end,
      desc = "Spectre » Search & replace",
    },
  },
}
