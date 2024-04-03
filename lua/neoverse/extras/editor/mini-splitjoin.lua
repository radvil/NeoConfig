return {
  "echasnovski/mini.splitjoin",
  -- event = "BufReadPre",
  keys = {
    {
      "<leader>uj",
      function()
        require("mini.splitjoin").toggle()
      end,
      desc = "split/[j]oin",
    },
    {
      "gS",
      function()
        require("mini.splitjoin").split()
      end,
      desc = "[S]plit arguments",
    },
    {
      "gJ",
      function()
        require("mini.splitjoin").join()
      end,
      desc = "[J]oin arguments",
    },
  },
  opts = {
    mappings = {
      toggle = "",
      split = "",
      join = "",
    },
  },
}
