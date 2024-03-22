---@diagnostic disable: missing-fields

return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = "nvim-treesitter/nvim-treesitter",
  event = "BufReadPre",
  opts = {
    enable = false,
    mode = "cursor",
    max_lines = 3,
  },
  keys = {
    {
      "<leader>ut",
      function()
        local tsc = require("treesitter-context")
        tsc.toggle()
        if Lonard.inject.get_upvalue(tsc.toggle, "enabled") then
          Lonard.info("Enabled", { title = "Treesitter Context" })
        else
          Lonard.warn("Disabled", { title = "Treesitter Context" })
        end
      end,
      desc = "toggle » treesitter context",
    },
  },
}
