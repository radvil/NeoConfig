local M = {}

M.keys = function()
  local ss = require("smart-splits")
  local Kmap = function(lhs, rhs, desc)
    return { lhs, rhs, mode = "n", desc = "Window » " .. desc }
  end
  --stylua: ignore
  return {
    -- resize keymaps
    Kmap("<c-up>", ss.resize_up, "Resize up"),
    Kmap("<c-down>", ss.resize_down, "Resize down"),
    Kmap("<c-left>", function() ss.resize_left(6) end, "Resize left"),
    Kmap("<c-right>", function() ss.resize_right(6) end, "Resize right"),

    -- navigation keymaps
    Kmap("<c-j>", ss.move_cursor_down, "Move cursor down"),
    Kmap("<c-k>", ss.move_cursor_up, "Move cursor up"),
    Kmap("<c-h>", ss.move_cursor_left, "Move cursor left"),
    Kmap("<c-l>", ss.move_cursor_right, "Move cursor right"),

    -- swap keymaps
    -- Kmap("<leader>wj", ss.swap_buf_down, "Swap down"),
    -- Kmap("<leader>wk", ss.swap_buf_up, "Swap up"),
    -- Kmap("<leader>wh", ss.swap_buf_left, "Swap left"),
    -- Kmap("<leader>wl", ss.swap_buf_right, "Swap right"),

    -- window operation
    Kmap("<leader>w<cr>", ss.start_resize_mode, "Start resize"),
  }
end

M.opts = {
  log_level = "info",
  ignored_buftypes = { "terminal", "prompt" },
  cursor_follows_swapped_bufs = true,
  ignored_filetypes = {
    "TelescopeResults",
    "TelescopePrompt",
    "neo-tree-popup",
    "DressingInput",
    "flash_prompt",
    "cmp_menu",
    "neo-tree",
    "WhichKey",
    "Outline",
    "prompt",
    "lspinfo",
    "notify",
    "mason",
    "noice",
    "noice",
    "lazy",
    "oil",
  },
  resize_mode = {
    quit_key = "q",
    resize_keys = { "h", "j", "k", "l" },
    silent = true,
    hooks = {
      on_enter = function()
        vim.notify("On: press <q> to exit!", vim.log.levels.INFO, { title = "Window resize" })
      end,
      on_leave = function()
        vim.notify("Off", vim.log.levels.WARN, { title = "Window resize" })
      end,
    },
  },
  ignored_events = {
    "BufEnter",
    "WinEnter",
  },
}

return M
