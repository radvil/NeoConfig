local M = {}

M.keys = {
  {
    "<Leader>Sr",
    ":NeoSessionRestore<Cr>",
    desc = "Session » Restore",
  },
  {
    "<Leader>Sl",
    function()
      require("persistence").load({ last = true })
    end,
    desc = "Session » Restore Last",
  },
  {
    "<Leader>Ss",
    function()
      require("persistence").stop()
    end,
    desc = "Session » Stop Persistence",
  },
}

M.opts = {
  options = {
    "buffers",
    "tabpages",
    "winsize",
    "curdir",
    "help",
  },
}

M.init = function()
  vim.api.nvim_create_user_command("NeoSessionRestore", function()
    require("persistence").load()
    require("neo-tree.command").execute({
      action = "show",
      reveal = true,
    })
  end, { desc = "Session » Restore" })
end

return M
