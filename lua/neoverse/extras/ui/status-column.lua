return {
  "luukvbaal/statuscol.nvim",
  event = "BufAdd",
  opts = function()
    local builtin = require("statuscol.builtin")
    return {
      relculright = true,
      ft_ignore = {
        "DiffviewFiles",
        "dashboard",
        "NvimTree",
        "neo-tree",
        "Outline",
        "Trouble",
      },
      segments = {
        {
          text = { "%s" },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc, " " },
          click = "v:lua.ScLa",
        },
        {
          text = { builtin.foldfunc, " " },
          click = "v:lua.ScFa",
        },
      },
    }
  end,
}
