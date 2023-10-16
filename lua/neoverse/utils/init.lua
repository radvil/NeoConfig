---@diagnostic disable: inject-field

local LazyUtil = require("lazy.core.util")

---@class neoverse.utils: LazyUtilCore
---@field inject neoverse.utils.inject
---@field lsp neoverse.utils.lsp
---@field root neoverse.utils.root
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

local root_pattern_fallback = { ".git", "lua" }

---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local rp = vim.loop.fs_realpath(p)
        if path:find(rp or 0, 1, true) then
          roots[#roots + 1] = rp
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(root_pattern_fallback, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@param ... any
---@return any | nil
function M.call(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  else
    return nil
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

function M.get_clients(...)
  ---@diagnostic disable-next-line: deprecated
  local fn = vim.lsp.get_clients or vim.lsp.get_active_clients
  return fn(...)
end

---@param callback fun(client, buffer)
function M.on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, buffer)
    end,
  })
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

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", {
    noremap = true,
    silent = true,
  }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    local opt = { title = "Option" }

    return require("lazy.core.util").info("Set " .. option .. " to " .. vim.opt_local[option]:get(), opt)
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()

  if not silent then
    local opt = { title = "Option" }
    if vim.opt_local[option]:get() then
      require("lazy.core.util").info("Enabled " .. option, opt)
    else
      require("lazy.core.util").warn("Disabled " .. option, opt)
    end
  end
end

---@type table<string,LazyFloat>
local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true })

  ---@cast opts LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?: true}
  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[termkey].buf
    vim.b[buf].lazyterm_cmd = cmd
    if opts.esc_esc == false then
      vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
    end
    if opts.ctrl_hjkl == false then
      vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
    end
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end
  return terminals[termkey]
end

return M
