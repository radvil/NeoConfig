local A = vim.api
local M = {}

local popups = {
  "TelescopeResults",
  "TelescopePrompt",
  "neo-tree-popup",
  "DressingInput",
  "flash_prompt",
  "cmp_menu",
  "WhichKey",
  "lspinfo",
  "incline",
  "notify",
  "prompt",
  "mason",
  "noice",
  "lazy",
  "oil",
}

local sidebars = {
  "neo-tree",
  "Outline",
}

M.opts = {
  show_prompt = false,
  hint = "floating-big-letter",
  prompt_message = "Window » Pick",
  filter_rules = {
    autoselect_one = true,
    include_current = false,
    bo = {
      buftype = { "terminal" },
      filetype = popups,
    },
  },
}

M.keys = {
  -- stylua: ignore
  {
    "<a-w>",
    function()
      local win = require("window-picker").pick_window({ include_current_win = false })
      if not win then return end
      A.nvim_set_current_win(win)
    end,
    desc = "window » pick",
  },
  {
    "<leader>ws",
    function()
      -- abort if current buffer ft is blacklisted
      local exclude_fts = vim.list_extend(vim.deepcopy(popups), sidebars)
      if vim.tbl_contains(exclude_fts, vim.bo.filetype) then
        require("neoverse.utils").warn("Can't swap current window!", { title = "Window picker" })
        return
      end
      local picked_win = require("window-picker").pick_window({
        include_current_win = false,
        filter_rules = {
          bo = {
            filetype = exclude_fts,
          },
        },
      })
      if not picked_win then
        return
      end
      local source_buf = A.nvim_get_current_buf()
      local picked_buf = A.nvim_win_get_buf(picked_win)
      A.nvim_win_set_buf(picked_win, source_buf)
      vim.schedule(function()
        A.nvim_win_set_buf(A.nvim_get_current_win(), picked_buf)
        -- cursor follow new buf's win
        A.nvim_set_current_win(picked_win)
      end)
    end,
    desc = "window » pick and swap",
  },
  {
    "<leader>wx",
    function()
      local picked = require("window-picker").pick_window({
        include_current_win = true,
        filter_rules = {
          bo = {
            filetype = popups,
          },
        },
      })
      if not picked then
        return
      end
      A.nvim_win_close(picked, false)
    end,
    desc = "window » pick and close",
  },
}

return M
