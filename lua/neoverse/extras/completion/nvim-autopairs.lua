return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
  keys = {
    {
      "<leader>up",
      function()
        local Util = require("lazy.core.util")
        if not require("nvim-autopairs").state.disabled then
          require("nvim-autopairs").disable()
          Util.warn("Disabled auto pairs", { title = "Option" })
        else
          require("nvim-autopairs").enable()
          Util.info("Enabled auto pairs", { title = "Option" })
        end
      end,
      desc = "toggle » auto pairs",
    },
  },
}
