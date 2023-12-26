---@diagnostic disable: undefined-field
local M = {}

M.init = function()
  vim.g.lualine_laststatus = vim.o.laststatus
  if vim.fn.argc(-1) > 0 then
    -- set an empty statusline till lualine loads
    vim.o.statusline = " "
  else
    -- hide the statusline on the starter page
    vim.o.laststatus = 0
  end
end

M.opts = function()
  -- PERF: we don't need this lualine require madness 🤷
  local lualine_require = require("lualine_require")
  lualine_require.require = require

  vim.o.laststatus = vim.g.lualine_laststatus

  local Config = require("neoverse.config")
  local Utils = require("neoverse.utils")
  local A = { "mode", Utils.lualine.root_dir() }
  local B = {
    {
      "filetype",
      icon_only = true,
      separator = "",
      padding = {
        left = 1,
        right = 0,
      },
    },
    { Utils.lualine.pretty_path() },
  }
  local C = {
    {
      "diagnostics",
      symbols = {
        error = Config.icons.Diagnostics.Error,
        warn = Config.icons.Diagnostics.Warn,
        info = Config.icons.Diagnostics.Info,
        hint = Config.icons.Diagnostics.Hint,
      },
    },
    {
      function()
        return require("nvim-navic").get_location()
      end,
      cond = function()
        return not Utils.lazy_has("barbecue") and package.loaded["nvim-navic"] and require("nvim-navic").is_available()
      end,
    },
  }
  local Y = {
    {
      function()
        return require("noice").api.status.mode.get()
      end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.mode.has()
      end,
      color = Utils.lualine.fg("Constant"),
    },
    {
      require("lazy.status").updates,
      cond = require("lazy.status").has_updates,
      color = Utils.lualine.fg("Special"),
    },
    {
      "diff",
      symbols = {
        added = Config.icons.Git.Added .. " ",
        modified = Config.icons.Git.Modified .. " ",
        removed = Config.icons.Git.Deleted .. " ",
      },
      source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end,
    },
  }
  local Z = {
    {
      function()
        return require("noice").api.status.command.get()
      end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.command.has()
      end,
    },
    {
      "progress",
      separator = " ",
      padding = {
        left = 1,
        right = 0,
      },
    },
    {
      "location",
      padding = {
        left = 0,
        right = 1,
      },
    },
  }

  if vim.g.neovide or not os.getenv("TMUX") then
    table.insert(B, 1, "branch")
  end

  return {
    extensions = { "neo-tree", "lazy", "oil" },
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = {
          "dashboard",
          "alpha",
        },
      },
    },
    sections = {
      lualine_a = A,
      lualine_b = B,
      lualine_c = C,
      lualine_x = {},
      lualine_y = Y,
      lualine_z = Z,
    },
  }
end

return M
