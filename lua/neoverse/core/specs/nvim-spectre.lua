local M = {}

M.keys = {
  {
    "<Leader>fr",
    function()
      require("spectre").open({
        cwd = require("neoverse.utils").root.get(),
      })
    end,
    desc = "Find and replace word (root)",
  },
  {
    "<Leader>fR",
    function()
      require("spectre").open({ cwd = vim.loop.cwd() })
    end,
    desc = "Find and replace word (cwd)",
  },
}

return M
