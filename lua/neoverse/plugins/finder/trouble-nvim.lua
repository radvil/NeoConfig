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
      ":TroubleToggle document_diagnostics<cr>",
      desc = "Diagnostics » Trouble (doc lvl)",
    },
    {
      "<Leader>xw",
      ":TroubleToggle workspace_diagnostics<Cr>",
      desc = "Diagnostics » Trouble (cwd lvl)",
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
