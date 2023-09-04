return {
  "mrjones2014/legendary.nvim",
  priority = 9999,
  lazy = false,
  keys = {
    {
      "<leader>q",
      ":Legendary<cr>",
      desc = "Quick Command/Keymaps Palette",
    },
  },
  config = function()
    require("legendary").setup({
      select_prompt = " Quick command/keymaps ",
      which_key = {
        auto_register = require("neoverse.common.utils").call("which-key") or false,
      },
      include_legendary_cmds = false,
      include_builtin = true,
      lazy_nvim = {
        auto_register = true,
      },
      extensions = {
        diffview = true,
        smart_splits = true,
      },
    })
  end,
}
