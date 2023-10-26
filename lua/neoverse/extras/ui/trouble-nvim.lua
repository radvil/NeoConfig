---@type LazySpec[]
local M = {}

M[1] = {
  "folke/trouble.nvim",
  event = "BufReadPost",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    {
      "<Leader>xd",
      "<cmd>TroubleToggle document_diagnostics<cr>",
      desc = "diagnostics » trouble [doc]",
    },
    {
      "<Leader>xw",
      "<cmd>TroubleToggle workspace_diagnostics<Cr>",
      desc = "diagnostics » trouble [cwd]",
    },
  },
}

local open_with_trouble = function(...)
  require("trouble.providers.telescope").open_with_trouble(...)
end

local open_selected_with_trouble = function(...)
  require("trouble.providers.telescope").open_selected_with_trouble(...)
end

M[2] = {
  "nvim-telescope/telescope.nvim",
  optional = true,
  opts = {
    defaults = {
      mappings = {
        ["n"] = { ["<a-x>"] = open_with_trouble, ["<a-t>"] = open_selected_with_trouble },
        ["i"] = { ["<a-x>"] = open_with_trouble, ["<a-t>"] = open_selected_with_trouble },
      },
    },
  },
}

return M
