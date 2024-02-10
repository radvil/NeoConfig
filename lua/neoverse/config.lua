---@diagnostic disable: inject-field
local Utils = require("neoverse.utils")

---@type NeoVerseOpts
local M = {}

---@class NeoVerseOpts
local defaults = {
  dev = false,

  ---@type string | function
  colorscheme = "catppuccin",

  builtins = {
    keymaps = true,
    autocmds = true,
  },

  palette = {
    dark = "#1E1E2E",
    dark2 = "#2F334D",
    light = "#ffffff",
    light2 = "#c8d3f5",
    sky = "#51AFEF",
    blue = "#89b4fa",
    pink = "#ff007c",
    pink2 = "#E76EB1",
    yellow = "#ffc777",
  },

  icons = {
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
      Boolean = "󰨙 ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      -- Interface = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
      Codeium = " ",
      Copilot = " ",
    },
    Misc = {
      Dots = "…",
    },
  },
}

M.json = {
  version = 2,
  data = {
    version = nil, ---@type string?
    extras = {}, ---@type string[]
  },
}

function M.json.load()
  local path = vim.fn.stdpath("config") .. "/neoverse.json"
  local f = io.open(path, "r")
  if f then
    local data = f:read("*a")
    f:close()
    local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
    if ok then
      M.json.data = vim.tbl_deep_extend("force", M.json.data, json or {}) or {}
      if M.json.data.version ~= M.json.version then
        Utils.json.migrate()
      end
    end
  end
end

---@type NeoVerseOpts | nil
local options = nil

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      Utils.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  -- always load builtins, then user file
  if M.builtins[name] or name == "options" then
    _load("neoverse.core." .. name)
  end
  _load("autoloads." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: NeoVerse may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
  local pattern = "NeoVerse" .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

---@diagnostic disable-next-line: inject-field
function M.bootstrap(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("NeoVerse", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")
      vim.api.nvim_create_user_command("NeoHealth", function()
        vim.cmd([[Lazy! load all]])
        vim.cmd([[checkhealth]])
      end, { desc = "Load all plugins and run :checkhealth" })
      Utils.root.setup()
      Utils.format.setup()
      Utils.extras.setup()
    end,
  })

  Utils.track("colorscheme")
  Utils.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      Utils.error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
  Utils.track()
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
  local plugin = require("lazy.core.config").spec.plugins.NeoVerse
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load("options")
  Utils.plugin.setup()
  M.json.load()
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
