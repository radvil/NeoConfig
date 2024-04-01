local feature_name = "Harpoon"

---@diagnostic disable: missing-fields
---@type LazySpec
local M = {}

---@param name string custom command name
---@param opts { desc: string, callback: function } custom options
local user_cmd = function(name, opts)
  vim.api.nvim_create_user_command(name, opts.callback, { desc = "[harpoon] " .. opts.desc })
end

local function get_buf_filepath()
  local opts = Lonard.opts("harpoon")
  local root = opts.default and opts.default.get_root_config and opts.default.get_root_config() or vim.uv.cwd()
  local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  return require("plenary.path"):new(buf_name):make_relative(root)
end

local append = function()
  local harpoon = require("harpoon")
  -- NOTE: hint for index
  local item = harpoon:list():get_by_display(get_buf_filepath())
  if not item then
    harpoon:list():append()
    Lonard.info("Appended to bookmark", {
      title = feature_name,
      icon = "📌",
    })
  else
    -- Get index of file bookmarked previously
    Lonard.warn("Already in the bookmark", { title = feature_name })
  end
end

local prepend = function()
  local harpoon = require("harpoon")
  local item = harpoon:list():get_by_display(get_buf_filepath())
  if not item then
    harpoon:list():prepend()
    Lonard.info("Prepended to bookmark", {
      title = feature_name,
      icon = "📌",
    })
  else
    Lonard.warn("Already in the bookmark", { title = feature_name })
  end
end

M.keys = {
  {
    "<Leader>ma",
    desc = "[harpoon] append to list",
    append,
  },
  {
    "<Leader>mI",
    desc = "[harpoon] prepend to list",
    prepend,
  },
  {
    [[<Leader>\]],
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "[harpoon] toggle quick menu",
  },
  {
    "<leader>[",
    function()
      require("harpoon"):list():prev()
    end,
    desc = "[harpoon] goto previous file",
  },
  {
    "<leader>]",
    function()
      require("harpoon"):list():next()
    end,
    desc = "[harpoon] goto next file",
  },

  {
    "<leader>1",
    function()
      require("harpoon"):list():select(1)
    end,
    desc = "[harpoon] goto file #1",
  },
  {
    "<leader>2",
    function()
      require("harpoon"):list():select(2)
    end,
    desc = "[harpoon] goto file #2",
  },
  {
    "<leader>3",
    function()
      require("harpoon"):list():select(3)
    end,
    desc = "[harpoon] goto file #3",
  },
  {
    "<leader>4",
    function()
      require("harpoon"):list():select(4)
    end,
    desc = "[harpoon] goto file #4",
  },
  {
    "<leader>5",
    function()
      require("harpoon"):list():select(5)
    end,
    desc = "[harpoon] goto file #5",
  },
}

---@type HarpoonConfig
M.opts = {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = false,
    key = function()
      ---@diagnostic disable-next-line: return-type-mismatch
      return vim.uv.cwd()
    end,
  },
  default = {
    get_root_config = function()
      return vim.uv.cwd()
    end,
  },
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
  user_cmd("HarpoonShowLogs", {
    desc = "show logs",
    callback = function()
      require("harpoon").logger:show()
    end,
  })

  user_cmd("M", {
    desc = "[harpoon] toggle quick menu",
    callback = function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list(), { border = "rounded" })
    end,
  })

  user_cmd("Mnext", {
    desc = "[harpoon] goto next file",
    callback = function()
      require("harpoon"):list():next()
    end,
  })

  user_cmd("Mprev", {
    desc = "[harpoon] goto previous file",
    callback = function()
      require("harpoon"):list():prev()
    end,
  })

  user_cmd("MA", {
    desc = "[harpoon] append to list",
    callback = append,
  })

  user_cmd("MI", {
    desc = "[harpoon] prepend to list",
    callback = prepend,
  })

  for i = 1, 5 do
    user_cmd("M" .. i, {
      desc = "[harpoon] select file #" .. i,
      callback = function()
        require("harpoon"):list():select(i)
      end,
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = Lonard.create_augroup("NeoHarpoon", true),
    command = "setlocal cursorline",
    pattern = "harpoon",
  })
end

return M
