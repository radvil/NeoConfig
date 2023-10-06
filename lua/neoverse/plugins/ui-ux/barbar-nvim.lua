local Kmap = function(lhs, cmd, desc)
  cmd = string.format("<cmd>Buffer%s", cmd)
  desc = string.format("Buffer » %s", desc)
  return { lhs, cmd, desc = desc }
end

return {
  "romgrk/barbar.nvim",
  version = "^1.0.0",
  dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  keys = {
    Kmap("<a-[>", "Previous", "Switch prev"),
    Kmap("<a-]>", "Next", "Switch next"),
    Kmap("<a-b>", "Pick", "Pick"),
    Kmap("<a-q>", "PickDelete", "Pick & close"),
    Kmap("<c-w>", "Wipeout", "Pick & close"),
    Kmap("<a-,>", "MovePrevious", "Shift left"),
    Kmap("<a-.>", "MoveNext", "Shift right"),
    Kmap("<leader>bl", "OrderByLanguage", "Order by directory"),
    Kmap("<leader>bs", "OrderByDirectory", "Order by directory"),
    Kmap("<leader>bS", "OrderByBufferNumber", "Order by buffer number"),
    Kmap("<leader>bp", "Pin", "Toggle pin"),
    Kmap("<leader>bB", "CloseBuffersLeft", "Close left"),
    Kmap("<leader>bW", "CloseBuffersRight", "Close right"),
    Kmap("<leader>bC", "CloseAllButCurrentOrPinned", "Close all but current/pinned"),
    Kmap("<a-1>", "Goto 1", "Switch 1st"),
    Kmap("<a-2>", "Goto 2", "Switch 2nd"),
    Kmap("<a-3>", "Goto 3", "Switch 3rd"),
    Kmap("<a-4>", "Goto 4", "Switch 4th"),
    Kmap("<a-5>", "Goto 5", "Switch 5th"),
  },

  opts = {
    animation = false,
    auto_hide = true,
    tabpages = true,
    clickable = true,
    focus_on_close = "left",
    highlight_alternate = false,
    highlight_inactive_file_icons = false,
    highlight_visible = true,
    insert_at_end = false,
    insert_at_start = false,
    no_name_title = nil,
    sidebar_filetypes = {
      ["neo-tree"] = { event = "BufWipeout" },
    },
    icons = {
      ---@type 'default' | 'powerline' | 'slanted'
      preset = "default",
      separator = { left = "▎", right = "" },
      separator_at_end = false,
      modified = { button = "●" },
      pinned = {
        button = "📌",
        -- button = "",
        filename = true,
      },
      current = {
        buffer_index = false,
        filetype = {
          enabled = true,
        },
      },
      inactive = {
        buffer_index = false,
        filetype = {
          enabled = false,
        },
      },
    },
    letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
  },
}
