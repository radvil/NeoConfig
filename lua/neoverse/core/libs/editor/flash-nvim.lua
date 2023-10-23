local M = {}

local ftMap = {
  popups = {
    "TelescopeResults",
    "TelescopePrompt",
    "DressingInput",
    "flash_prompt",
    "cmp_menu",
    "WhichKey",
    "prompt",
    "notify",
    "noice",
  },
  excludes = {
    "DiffviewFiles",
    "NeogitStatus",
    "Dashboard",
    "dashboard",
    "MundoDiff",
    "NvimTree",
    "neo-tree",
    "Outline",
    "prompt",
    "Mundo",
    "alpha",
    "help",
    "dbui",
    "edgy",
    "dirbuf",
    "fugitive",
    "fugitiveblame",
    "gitcommit",
    "Trouble",
    "alpha",
    "help",
    "qf",
  },
}

---@type LazySpec
M[1] = {
  "folke/flash.nvim",
  lazy = true,
  ---@type function
  keys = function()
    return {
      {
        "<a-m>",
        mode = "n",
        function()
          require("flash").jump({
            search = {
              exclude = ftMap.popups,
              autojump = false,
              forward = true,
              wrap = true,
            },
          })
        end,
        desc = "Flash » Jump",
      },
      {
        "<a-m>",
        mode = { "x", "o" },
        function()
          require("flash").jump({
            search = {
              multi_window = false,
              forward = true,
              wrap = true,
            },
          })
        end,
        desc = "Flash » Jump",
      },
      {
        "<a-s>",
        mode = { "x", "v" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash » Select node",
      },
      {
        "<a-s>",
        mode = "n",
        function()
          require("flash").treesitter_search({
            search = {
              exclude = ftMap.excludes,
            },
          })
        end,
        desc = "Treesitter » Search range",
      },
      {
        "<a-s>",
        function()
          local curr_win = vim.api.nvim_get_current_win()
          local curr_view = vim.fn.winsaveview()
          require("flash").jump({
            action = function(target, state)
              state:hide()
              vim.api.nvim_set_current_win(target.win)
              vim.api.nvim_win_set_cursor(target.win, target.pos)
              require("flash").treesitter({
                search = {
                  exclude = ftMap.excludes,
                },
              })
              vim.schedule(function()
                vim.api.nvim_set_current_win(curr_win)
                if curr_view then
                  vim.fn.winrestview(curr_view)
                end
              end)
            end,
          })
        end,
        mode = "o",
        desc = "Treesitter » Select parent range",
      },
    }
  end,

  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      mode = "exact",
      forward = true,
      multi_window = true,
      incremental = false,
    },
    jump = {
      jumplist = true,
      pos = "start", ---@type "start" | "end" | "range"
      history = false,
      register = false,
      nohlsearch = true,
      autojump = false,
      -- --stylua: ignore
      filetype_exclude = ftMap.excludes,
    },
    label = {
      current = true,
      after = false,
      before = true,
      reuse = "lowercase",
    },
    highlight = {
      backdrop = true,
      matches = true,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    modes = {
      search = { enabled = false },
      char = { enabled = false },
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        backdrop = false,
        matches = false,
        label = {
          before = true,
          after = true,
          style = "inline",
        },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
    },
  },
}

local pick_with_flash = function(prompt_bufnr)
  require("flash").jump({
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  })
end

M[2] = {
  "nvim-telescope/telescope.nvim",
  optional = true,
  opts = {
    defaults = {
      mappings = {
        ["n"] = { ["<a-m>"] = pick_with_flash },
        ["i"] = { ["<a-m>"] = pick_with_flash },
      },
    },
  },
}

return M
