return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },

  keys = {
    {
      "<leader>gd",
      ":DiffviewOpen<cr>",
      desc = "Git » Open diff view",
    },
    {
      "<leader>gh",
      ":DiffviewFileHistory<cr>",
      desc = "Git » Open file history",
    },
  },

  opts = {
    hooks = {
      diff_buf_read = function(_)
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.colorcolumn = { 80 }
      end,
      view_opened = function(view)
        local msg = "%s » Opened on tabpage %d"
        vim.notify(msg:format(view.class:name(), view.tabpage), vim.log.levels.INFO)
      end,
      view_closed = function(view)
        local msg = "%s » Closed on tabpage %d"
        vim.notify(msg:format(view.class:name(), view.tabpage), vim.log.levels.WARN)
      end,
    },
  },
}
