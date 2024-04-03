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
        "<leader>xb",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "[b]uffer diagnosti[x]",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "[w]orkspace diagnosti[x]",
      },
      {
        "<leader>xl",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "diagnosti[x] [l]oclist",
      },
      {
        "<leader>xq",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "diagnosti[x] [q]uickfix",
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
