return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = function(_, opts)
    local view_active = false
    local gitsigns = require("gitsigns")

    opts.current_line_blame_opts = {
      delay = 1000,
      virt_text_pos = "right_align",
      virt_text_priority = 100,
    }

    opts.signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    }

    opts.on_attach = function(buffer)
      ---@param lhs string
      ---@param rhs function | string
      ---@param desc string
      local map = function(lhs, rhs, desc)
        return vim.keymap.set("n", lhs, rhs, {
          desc = "Gitsign » " .. desc,
          buffer = buffer,
        })
      end

      map("<leader>gr", function()
        gitsigns.refresh()
        vim.notify("View refreshed", vim.log.levels.INFO, { title = "Gitsigns" })
      end, "Refresh view")

      map("<leader>gu", function()
        gitsigns.toggle_signs()
        gitsigns.toggle_numhl()
        gitsigns.toggle_linehl()
        gitsigns.toggle_current_line_blame()
        view_active = not view_active
        local lvl = view_active and "info" or "warn"
        local state = view_active and "enabled" or "disabled"
        vim.notify("View status " .. state, lvl, { title = "Gitsigns" })
      end, "Toggle buffer status")
    end
  end,
}
