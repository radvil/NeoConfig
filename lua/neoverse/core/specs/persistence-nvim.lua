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
  options = vim.opt.sessionoptions:get(),
}

M.init = function()
  vim.api.nvim_create_user_command("NeoSessionRestore", function()
    require("persistence").load()
    if require("neoverse.utils").lazy_has("neo-tree.nvim") then
      require("neo-tree.command").execute({
        dir = require("neoverse.utils").root.get(),
        position = "left",
        action = "show",
        selector = true,
        reveal = true,
      })
    end
  end, { desc = "Session » Restore" })
end

return M
