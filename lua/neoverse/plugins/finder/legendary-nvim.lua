return {
  "mrjones2014/legendary.nvim",
  priority = 9999,
  lazy = false,
  keys = {
    {
      "<leader>q",
      "<cmd>Legendary<cr>",
      desc = "Quick Command/Keymaps Palette",
    },
  },
  config = function()
    require("legendary").setup({
      select_prompt = " Quick command/keymaps ",
      include_legendary_cmds = false,
      include_builtin = true,
      extensions = {
        diffview = true,
        smart_splits = true,
        which_key = {
          auto_register = require("neoverse.utils").call("which-key") or false,
        },
        lazy_nvim = {
          auto_register = true,
        },
      },
    })
  end,
}
