---@diagnostic disable: missing-fields
local M = {}

M.keys = {
  {
    "<Leader>ma",
    function()
      require("harpoon"):list():append()
      Lonard.info("file appended to bookmarked", {
        title = "Harpoon",
        icon = "📌",
      })
    end,
    desc = "[harpoon] append to list",
  },
  {
    "<Leader>mI",
    function()
      require("harpoon"):list():prepend()
      Lonard.info("file prepended to bookmarked", {
        title = "Harpoon",
        icon = "📌",
      })
    end,
    desc = "[harpoon] prepend to list",
  },
  {
    [[<Leader>\]],
    function()
      require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
    end,
    desc = "[harpoon] toggle quick menu",
  },
  {
    "[f",
    function()
      require("harpoon"):list():prev()
    end,
    desc = "[harpoon] goto previous file",
  },
  {
    "]f",
    function()
      require("harpoon"):list():next()
    end,
    desc = "[harpoon] goto next file",
  },
}

M.opts = {
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

M.init = function()
  vim.api.nvim_create_user_command("M", function()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
  end, { desc = "[harpoon] toggle quick menu" })
  for i = 1, 5 do
    vim.api.nvim_create_user_command("M" .. i, function()
      require("harpoon"):list():select(i)
    end, { desc = "[harpoon] select file #" .. i })
  end
end

return M
