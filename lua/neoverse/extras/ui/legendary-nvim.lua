return {
  "mrjones2014/legendary.nvim",
  dependencies = "folke/which-key.nvim",
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
        smart_splits = false,
        which_key = {
          auto_register = true,
        },
        lazy_nvim = {
          auto_register = true,
        },
      },
    })
  end,
}
