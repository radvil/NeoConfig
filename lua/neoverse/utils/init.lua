---@diagnostic disable: inject-field

local LazyUtil = require("lazy.core.util")

---@class neoverse.utils: LazyUtilCore
---@field terminal neoverse.utils.terminal
---@field lazygit neoverse.utils.lazygit
---@field lualine neoverse.utils.lualine
---@field inject neoverse.utils.inject
---@field toggle neoverse.utils.toggle
---@field extras neoverse.utils.extras
---@field format neoverse.utils.format
---@field plugin neoverse.utils.plugin
---@field root neoverse.utils.root
---@field json neoverse.utils.json
---@field lsp neoverse.utils.lsp
---@field ui neoverse.utils.ui
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    t[k] = require("neoverse.utils." .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---check buffer against given mapping list or string
---@param bufnr integer | nil
---@param mappings table | string
function M.buf_has_keymaps(mappings, mode, bufnr)
  local ret = false
  bufnr = bufnr or 0
  mode = mode or "n"
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return ret
  end
  mappings = (type(mappings) == "table" and mappings) or (type(mappings) == "string" and { mappings }) or {}
  local buf_keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)
  for _, value in ipairs(mappings) do
    if not not vim.tbl_contains(buf_keymaps, value) then
      ret = true
      break
    end
  end
  return ret
end

---@param ... any
---@return any | false
function M.call(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  else
    return false
  end
end

---@param opts? {level?: number}
function M.pretty_trace(opts)
  opts = opts or {}
  local Config = require("lazy.core.config")
  local trace = {}
  local level = opts.level or 2
  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end
    if info.what ~= "C" and not info.source:find("lazy.nvim") then
      local source = info.source:sub(2)
      if source:find(Config.options.root, 1, true) == 1 then
        source = source:sub(#Config.options.root + 1)
      end
      source = vim.fn.fnamemodify(source, ":p:~:.") --[[@as string]]
      local line = "  - " .. source .. ":" .. info.currentline
      if info.name then
        line = line .. " _in_ **" .. info.name .. "**"
      end
      table.insert(trace, line)
    end
    level = level + 1
  end
  return #trace > 0 and ("\n\n# stacktrace:\n" .. table.concat(trace, "\n")) or ""
end

---@param msg string|string[]
---@param opts? any
function M.notify(msg, opts)
  if vim.in_fast_event() then
    return vim.schedule(function()
      M.notify(msg, opts)
    end)
  end

  opts = opts or {}
  if type(msg) == "table" then
    msg = table.concat(
      vim.tbl_filter(function(line)
        return line or false
      end, msg),
      "\n"
    )
  end
  if opts.stacktrace then
    msg = msg .. M.pretty_trace({ level = opts.stacklevel or 2 })
  end
  local lang = opts.lang or "markdown"
  local n = opts.once and vim.notify_once or vim.notify
  n(msg, opts.level or vim.log.levels.INFO, {
    on_open = function(win)
      local ok = pcall(function()
        vim.treesitter.language.add("markdown")
      end)
      if not ok then
        pcall(require, "nvim-treesitter")
      end
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].filetype = lang
        vim.bo[buf].syntax = lang
      end
    end,
    title = opts.title or "lazy.nvim",
  })
end

---@param msg string|string[]
---@param opts? notify.Options
function M.error(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? notify.Options
function M.info(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? notify.Options
function M.warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

function M.debug(msg)
  if not require("neoverse.config").dev then
    return
  end
  local title = string.format("[%s]", "DEBUG")
  vim.notify(msg, vim.log.levels.INFO, { title })
end

---@param plugin string
function M.lazy_has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param callback fun()
function M.on_very_lazy(callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      callback()
    end,
  })
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

---@param scope string
---@param clear? boolean
function M.create_augroup(scope, clear)
  clear = type(clear) == "nil" and true or clear
  return vim.api.nvim_create_augroup("neoverse_" .. scope, { clear = clear })
end

---@param fpath string
function M.open_with_system_default(fpath)
  if vim.ui.open then
    vim.ui.open(fpath)
  else
    ---@diagnostic disable-next-line: undefined-field
    local uname = vim.uv.os_uname()
    local OS = uname.sysname
    local is_mac = OS == "Darwin"
    local is_linux = OS == "Linux"
    local is_windows = OS:find("Windows") and true or false
    local is_wsl = is_linux and uname.release:lower():find("microsoft") and true or false
    if is_mac then
      os.execute("open " .. string.format("'%s'", fpath))
    elseif is_wsl then
      os.execute("wslview " .. string.format("'%s'", fpath))
    elseif is_linux then
      os.execute("xdg-open " .. string.format("'%s'", fpath))
    elseif is_windows then
      os.execute("start " .. string.format("'%s'", fpath))
    else
      ---@diagnostic disable-next-line: missing-fields
      M.warn("OS not detected", { title = "Neo-Tree" })
    end
  end
end

return M
