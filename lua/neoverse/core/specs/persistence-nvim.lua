local M = {}

M.keys = {
  {
    "<Leader>Sr",
    function()
      require("persistence").load()
    end,
    desc = "session » restore",
  },
  {
    "<Leader>Sl",
    function()
      require("persistence").load({ last = true })
    end,
    desc = "session » restore last",
  },
  {
    "<Leader>Ss",
    function()
      require("persistence").stop()
    end,
    desc = "session » stop persistence",
  },
}

M.opts = {
  options = vim.opt.sessionoptions:get(),
}

return M
