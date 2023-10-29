return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  opts = {
    enable = false,
    mode = "cursor",
    max_lines = 3,
  },
  keys = {
    {
      "<leader>ut",
      function()
        local Utils = require("neoverse.utils")
        local tsc = require("treesitter-context")
        tsc.toggle()
        if Utils.inject.get_upvalue(tsc.toggle, "enabled") then
          Utils.info("Enabled", { title = "Treesitter Context" })
        else
          Utils.warn("Disabled", { title = "Treesitter Context" })
        end
      end,
      desc = "Toggle » Treesitter Context",
    },
  },
}
