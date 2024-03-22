local M = {}

M.keys = {
  {
    "<leader>mf",
    function()
      require("harpoon.mark").add_file()
      ---@diagnostic disable-next-line: missing-fields
      Lonard.info("file marked", {
        title = "Harpoon",
        icon = "📌",
      })
    end,
    desc = "harpoon » mark",
  },
  {
    [[<leader>\]],
    function()
      require("harpoon.ui").toggle_quick_menu()
    end,
    desc = "harpoon » toggle file list",
  },
  {
    "[f",
    function()
      require("harpoon.ui").nav_prev()
    end,
    desc = "harpoon » goto the prev file",
  },
  {
    "]f",
    function()
      require("harpoon.ui").nav_next()
    end,
    desc = "harpoon » goto the next file",
  },
}

M.opts = {
  mark_branch = false,
  save_on_change = false,
  save_on_toggle = false,
  enter_on_sendcmd = false,
  tmux_autoclose_windows = false,
  menu = {
    width = vim.api.nvim_win_get_width(0) - 50,
  },
  excluded_filetypes = {
    -- popups
    "TelescopeResults",
    "TelescopePrompt",
    "neo-tree-popup",
    "DressingInput",
    "flash_prompt",
    "cmp_menu",
    "WhichKey",
    "lspinfo",
    "prompt",
    "notify",
    "noice",
    "mason",
    "noice",
    "lazy",
    "oil",

    -- windows
    "NeogitStatus",
    "fugitiveblame",
    "DiffviewFiles",
    "Dashboard",
    "dashboard",
    "gitcommit",
    "MundoDiff",
    "fugitive",
    "NvimTree",
    "neo-tree",
    "Outline",
    "Trouble",
    "dirbuf",
    "prompt",
    "Mundo",
    "alpha",
    "edgy",
    "help",
    "dbui",
    "qf",
  },
}

return M
