local M = {}
M[1] = "s1n7ax/nvim-window-picker"

M.config = function()
  local picker = require("window-picker")
  local filetypes = {
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
  }

  picker.setup({
    show_prompt = false,
    hint = "floating-big-letter",
    prompt_message = "Window » Pick",
    filter_rules = {
      autoselect_one = true,
      include_current = false,
      bo = {
        buftype = { "terminal" },
        filetype = filetypes,
      },
    },
  })

  -- stylua: ignore
  local pick_window = function()
    local win = picker.pick_window({ include_current_win = false })
    if not win then win = vim.api.nvim_get_current_win() end
    vim.api.nvim_set_current_win(win)
  end

  -- stylua: ignore
  local swap_window = function()
    local curr_win = vim.api.nvim_get_current_win()
    local target_win = picker.pick_window({ include_current_win = false })

    if not target_win then target_win = curr_win end
    local target_ft = vim.api.nvim_get_option_value("filetype", { win = target_win })

    if vim.tbl_contains(filetypes, target_ft) then
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
  end

  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      desc = string.format("Window » %s", desc),
    })
  end

  map("<a-w>", pick_window, "Select with picker")
  map("<leader>ws", swap_window, "Swap with picker")
end

return M
