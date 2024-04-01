return {
  "echasnovski/mini.splitjoin",
  -- event = "BufReadPre",
  keys = {
    {
      "<leader>uj",
      function()
        require("mini.splitjoin").toggle()
      end,
      desc = "toggle » split/join",
    },
    {
      "gS",
      function()
        require("mini.splitjoin").split()
      end,
      desc = "split arguments",
    },
    {
      "gJ",
      function()
        require("mini.splitjoin").join()
      end,
      desc = "join arguments",
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
