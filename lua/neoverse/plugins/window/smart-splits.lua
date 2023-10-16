return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  config = function()
    local o = { title = "Window resize" }
    require("smart-splits").setup({
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
            vim.notify("On: press <q> to exit!", vim.log.levels.INFO, o)
          end,
          on_leave = function()
            vim.notify("Off", vim.log.levels.WARN, o)
          end,
        },
      },
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
    })
  end,
  init = function()
    local ss = require("smart-splits")
    local map = function(lhs, rhs, desc)
      return vim.keymap.set("n", lhs, rhs, {
        desc = "Window » " .. desc,
      })
    end

    --stylua: ignore start
    -- resize keymaps
    map("<c-up>", ss.resize_up, "Resize up")
    map("<c-down>", ss.resize_down, "Resize down")
    map("<c-left>", function() ss.resize_left(6) end, "Resize left")
    map("<c-right>", function() ss.resize_right(6) end, "Resize right")

    -- navigation keymaps
    map("<c-j>", ss.move_cursor_down, "Move cursor down")
    map("<c-k>", ss.move_cursor_up, "Move cursor up")
    map("<c-h>", ss.move_cursor_left, "Move cursor left")
    map("<c-l>", ss.move_cursor_right, "Move cursor right")

    -- swap keymaps
    map("<leader>wj", ss.swap_buf_down, "Swap down")
    map("<leader>wk", ss.swap_buf_up, "Swap up")
    map("<leader>wh", ss.swap_buf_left, "Swap left")
    map("<leader>wl", ss.swap_buf_right, "Swap right")

    -- window operation
    map("<leader>w<cr>", ss.start_resize_mode, "Start resize")
  end,
}
