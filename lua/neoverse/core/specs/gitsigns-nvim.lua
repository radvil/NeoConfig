local M = {}

local view_active = false

M.keys = {
  {
    "<leader>gr",
    function()
      require("gitsigns").refresh()
      vim.notify("View refreshed", vim.log.levels.INFO, { title = "Gitsigns" })
    end,
    desc = "Refresh view",
  },
  {
    "<leader>gu",
    function()
      local gs = require("gitsigns")
      gs.toggle_signs()
      gs.toggle_numhl()
      gs.toggle_linehl()
      gs.toggle_current_line_blame()
      view_active = not view_active
      local lvl = view_active and "info" or "warn"
      local state = view_active and "enabled" or "disabled"
      vim.notify("View status " .. state, lvl, { title = "Gitsigns" })
    end,
    desc = "Toggle buffer status",
  },
}

M.opts = {
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
    delay = 1000,
  },
}

return M
