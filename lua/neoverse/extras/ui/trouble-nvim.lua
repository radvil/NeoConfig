local open_with_trouble = function(...)
  require("trouble.providers.telescope").open_with_trouble(...)
end

local open_selected_with_trouble = function(...)
  require("trouble.providers.telescope").open_selected_with_trouble(...)
end

---@type LazySpec[]
return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "diagnostics » document [trouble]",
      },
      {
        "<leader>xX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "diagnostics » workspace [trouble]",
      },
      {
        "<leader>xL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "diagnostics » location list [trouble]",
      },
      {
        "<leader>xQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "diagnostics » quickfix [trouble]",
      },
    },
  },

  -- extends telescope actions
  {
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
  },
}
