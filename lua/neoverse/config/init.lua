---@type NeoVerseOpts
local M = {}

---@class NeoVerseOpts
local defaults = {
  dev = true,
  darkmode = true,
  transparent = false,

  ---@type string|fun()
  colorscheme = function()
    require("tokyonight").load()
  end,

  ---@type fun() | nil
  before_config_init = nil,

  ---@type fun() | nil
  after_config_init = nil,

  ---@type (fun(): string) | string | nil
  note_dir = nil,

  ---@type (fun(): table<string>) | table<string> | nil
  snippet_dirs = {},

  palette = {
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
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
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

function M.bootstrap(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  if M.before_config_init then
    M.before_config_init()
  end

  if M.after_config_init then
    if vim.fn.argc(-1) == 0 then
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("NeoVerse", { clear = true }),
        pattern = "VeryLazy",
        callback = function()
          M.after_config_init()
        end,
      })
    else
      M.after_config_init()
    end
  end

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
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
