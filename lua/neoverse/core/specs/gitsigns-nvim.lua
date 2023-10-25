local M = {}
local Utils = require("neoverse.utils")

M.keys = {
  {
    "<leader>gr",
    function()
      require("gitsigns").refresh()
      Utils.info("Gitsigns refreshed", { title = "Gitsigns" })
    end,
    desc = "Gitsigns » Refresh view",
  },
  {
    "<leader>gu",
    desc = "Gitsigns » Toggle",
  },
  {
    "<leader>gun",
    ":Gitsigns toggle_numhl<cr>",
    desc = "Gitsigns » Toggle Number Hl",
  },
  {
    "<leader>guu",
    ":Gitsigns toggle_signs<cr>",
    desc = "Gitsigns » Toggle SignColumn Hl",
  },
  {
    "<leader>gub",
    ":Gitsigns toggle_current_line_blame<cr>",
    desc = "Gitsigns » Toggle Line Blame",
  },
  {
    "<leader>gud",
    ":Gitsigns toggle_word_diff<cr>",
    desc = "Gitsigns » Toggle Word Diff",
  },
}

M.opts = {
  signcolumn = true,
  numhl = false,
  current_line_blame = false,
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▎" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  current_line_blame_opts = {
    virt_text_pos = "right_align",
    virt_text_priority = 100,
    delay = 300,
  },
}

return M
