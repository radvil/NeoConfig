---@diagnostic disable: duplicate-set-field
local M = {}

M.opts = {
  input = {
    border = "single",
    relative = "editor",
    win_options = { winblend = 10 },
    mappings = {
      i = { ["<a-space>"] = "Close" },
    },
  },
}

M.init = function()
  vim.ui.select = function(...)
    require("lazy").load({ plugins = { "dressing.nvim" } })
    return vim.ui.select(...)
  end
  vim.ui.input = function(...)
    require("lazy").load({ plugins = { "dressing.nvim" } })
    return vim.ui.input(...)
  end
end

M.config = function(_, opts)
  if vim.g.neo_transparent then
    opts.input.win_options.winblend = 0
  end
  require("dressing").setup(opts)
end

return M
