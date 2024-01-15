---@diagnostic disable: missing-fields, duplicate-set-field

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

M.config = function(_, opts)
  ---@param msg string
  ---@param severity string?
  local notify = function(msg, severity)
    severity = severity or "info"
    require("neoverse.utils")[severity](msg, {
      title = "persistence.nvim",
      animate = false,
    })
  end

  local persistence_nvim = require("persistence")
  local load_session = persistence_nvim.load
  local stop_session = persistence_nvim.stop

  persistence_nvim.load = function()
    load_session()
    notify("session restored")
  end

  persistence_nvim.stop = function()
    stop_session()
    notify("session stopped", "warn")
  end

  persistence_nvim.setup(opts)
end

return M
