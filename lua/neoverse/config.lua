---@diagnostic disable: inject-field
---@type NeoVerseOpts
local M = {}

---@class NeoVerseOpts
local defaults = {
  dev = false,
  darkmode = true,
  transparent = false,

  ---@type string | function
  colorscheme = "tokyonight",

  ---@type fun() | nil
  before_config_init = nil,

  ---@type fun() | nil
  after_config_init = nil,

  ---@type (fun(): string) | string | nil
  note_dir = nil,

  ---@type (fun(): table<string>) | table<string> | nil
  snippet_dirs = {},

  palette = {
    bg_darker = "#181826",
    bg = "#1E1E2E",
    bg2 = "#2F334D",
    fg = "#ffffff",
    fg2 = "#c8d3f5",
    blue = "#3e68d7",
    blue2 = "#51AFEF",
    cyan = "#0DB9D7",
    green = "#6DD390",
    orange = "#FF855A",
    red = "#FF0000",
    red2 = "#EC5F67",
    pink = "#ff007c",
    pink2 = "#E76EB1",
    magenta = "#C678DD",
    violet = "#A9A1E1",
    gold = "#e0af68",
    yellow = "#ffc777",
    yellow2 = "#dbb67d",
  },

  --TODO: reformat icons options
  icons = {
    Folds = {
      Collapsed = "",
      Expanded = "",
    },
    Mason = {
      package_uninstalled = "◍ ",
      package_installed = "",
      package_pending = "",
    },
    Diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    Git = {
      Added = "",
      Deleted = "",
      Modified = "",
      Renamed = "",
      Staged = "",
      Unstaged = "󰅗",
      Untracked = "",
      Conflict = "",
      Ignored = "",
    },
    Kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
}

---@type NeoVerseOpts | nil
local options = nil

---@diagnostic disable-next-line: inject-field
function M.bootstrap(opts)
  local LazyUtil = require("lazy.core.util")
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

  if M.before_config_init then
    M.before_config_init()
  end

  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("NeoVerse", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        if M.after_config_init then
          M.after_config_init()
        end
      end,
    })
  end

  LazyUtil.track("colorscheme")
  LazyUtil.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      LazyUtil.error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
  LazyUtil.track()
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
  local plugin = require("lazy.core.config").spec.plugins.LazyVim
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end

  local PluginUtil = require("neoverse.utils.plugin")
  PluginUtil.lazy_notify()
  PluginUtil.lazy_file()
end

---TODO: Learn about this metatable thing!!!
---@diagnostic disable-next-line: inject-field
function M.set(key, value)
  if options == nil then
    defaults[key] = value
  else
    options[key] = value
  end
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options NeoVerseOpts
    return options[key]
  end,
})

return M
