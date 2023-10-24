local M = {}

M.opts = {
  show_prompt = false,
  hint = "floating-big-letter",
  prompt_message = "Window » Pick",
  filter_rules = {
    autoselect_one = true,
    include_current = false,
    bo = {
      buftype = { "terminal" },
      filetype = {
        "TelescopeResults",
        "TelescopePrompt",
        "neo-tree-popup",
        "DressingInput",
        "flash_prompt",
        "cmp_menu",
        "neo-tree",
        "WhichKey",
        "lspinfo",
        "Outline",
        "notify",
        "prompt",
        "mason",
        "noice",
        "lazy",
        "oil",
      },
    },
  },
}

M.keys = {
  {
    "<a-w>",
    function()
      local win = require("window-picker").pick_window({ include_current_win = false })
      if not win then
        win = vim.api.nvim_get_current_win()
      end
      vim.api.nvim_set_current_win(win)
    end,
    desc = "Window » Select with picker",
  },
  {
    "<leader>ws",
    function()
      local curr_win = vim.api.nvim_get_current_win()
      local target_win = require("window-picker").pick_window({ include_current_win = false })
      if not target_win then
        target_win = curr_win
      end
      local target_ft = vim.api.nvim_get_option_value("filetype", { win = target_win })
      if vim.tbl_contains(M.opts.filter_rules.bo.filetype, target_ft) then
        vim.notify("Not possible!", vim.log.levels.WARN, {
          title = "Window picker",
        })
        return
      end
      vim.api.nvim_win_set_buf(target_win, 0)
      vim.api.nvim_set_current_win(target_win)
      local target_buf = vim.fn.winbufnr(target_win)
      if type(target_buf) == "number" then
        vim.api.nvim_win_set_buf(0, target_buf)
      end
    end,
    desc = "Swap with picker",
  },
}

return M
