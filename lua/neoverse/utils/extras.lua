local Config = require("neoverse.config")
local LazyFloat = require("lazy.view.float")
local LazyConfig = require("lazy.core.config")
local LazyPlugin = require("lazy.core.plugin")
local LazyText = require("lazy.view.text")

---@class NeoExtraSource
---@field name string
---@field desc? string
---@field module string

---@class NeoExtra
---@field name string
---@field source NeoExtraSource
---@field module string
---@field desc? string
---@field enabled boolean
---@field managed boolean
---@field recommended? boolean
---@field row? number
---@field section? string
---@field plugins string[]
---@field optional string[]

---@class neoverse.utils.extras
local M = {}
M.buf = 0

---@type NeoExtraSource[]
M.sources = {
  { name = "NeoVerse", desc = "NeoVerse extras", module = "neoverse.extras" },
  { name = "User", desc = "User extras", module = "extras" },
}

M.ns = vim.api.nvim_create_namespace("neoverse.extras")
---@type string[]
M.state = nil

---@param opts {ft?: string|string[], root?: string|string[]}
---@return boolean
function M.wants(opts)
  if opts.ft then
    opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[M.buf].filetype == f then
        return true
      end
    end
  end
  if opts.root then
    opts.root = type(opts.root) == "string" and { opts.root } or opts.root
    return #Lonard.root.detectors.pattern(M.buf, opts.root) > 0
  end
  return false
end

---@return NeoExtra[]
function M.get()
  M.state = M.state or LazyConfig.spec.modules
  local extras = {} ---@type NeoExtra[]
  for _, source in ipairs(M.sources) do
    local root = Lonard.find_root(source.module)
    if root then
      Lonard.walk(root, function(path, name, type)
        if (type == "file" or type == "link") and name:match("%.lua$") then
          name = path:sub(#root + 2, -5):gsub("/", ".")
          local ok, extra = pcall(M.get_extra, source, source.module .. "." .. name)
          if ok then
            extras[#extras + 1] = extra
          end
        end
      end)
    end
  end
  table.sort(extras, function(a, b)
    return a.name < b.name
  end)
  return extras
end

---@param modname string
---@param source NeoExtraSource
function M.get_extra(source, modname)
  local enabled = vim.tbl_contains(M.state, modname)
  local spec = LazyPlugin.Spec.new({ import = modname }, { optional = true })
  local plugins = {} ---@type string[]
  local optional = {} ---@type string[]
  for _, p in pairs(spec.plugins) do
    if p.optional then
      optional[#optional + 1] = p.name
    else
      plugins[#plugins + 1] = p.name
    end
  end
  table.sort(plugins)
  table.sort(optional)
  ---@type boolean|(fun():boolean?)|nil
  local recommended = require(modname).recommended or false
  if type(recommended) == "function" then
    recommended = recommended() or false
  end
  ---@type NeoExtra
  return {
    source = source,
    name = modname:sub(#source.module + 2),
    module = modname,
    enabled = enabled,
    desc = require(modname).desc,
    recommended = recommended,
    managed = vim.tbl_contains(Config.json.data.extras, modname) or not enabled,
    plugins = plugins,
    optional = optional,
  }
end

---@param prios table<string,number>
function M.get_specs_by_prios(prios)
  local used = {} ---@type table<string, boolean>
  ---@type string[]
  Config.json.data.extras = vim.tbl_filter(function(extra)
    if used[extra] then
      return false
    end
    used[extra] = true
    return true
  end, Config.json.data.extras)
  table.sort(Config.json.data.extras, function(a, b)
    local pa = prios[a] or 10
    local pb = prios[b] or 10
    if pa == pb then
      return a < b
    end
    return pa < pb
  end)
  ---@param extra string
  return vim.tbl_map(function(extra)
    return { import = extra }
  end, Config.json.data.extras)
end

---@class NeoPluginView
---@field float LazyFloat
---@field text Text
---@field extras NeoExtra[]
---@field diag LazyDiagnostic[]
local V = {}

---@return NeoPluginView
function V.new()
  local self = setmetatable({}, { __index = V })
  self.float = LazyFloat.new({ title = "NeoVerse Extras", border = vim.g.neo_winborder })
  self.float:on_key("x", function()
    self:toggle()
  end, "Toggle extra")
  self.diag = {}
  self:update()
  return self
end

---@param diag LazyDiagnostic
function V:diagnostic(diag)
  diag.row = diag.row or self.text:row()
  diag.severity = diag.severity or vim.diagnostic.severity.INFO
  table.insert(self.diag, diag)
end

function V:toggle()
  local pos = vim.api.nvim_win_get_cursor(self.float.win)
  for _, plug in ipairs(self.extras) do
    if plug.row == pos[1] then
      if not plug.managed then
        Lonard.error(
          "Not managed by NeoExtras. Remove from your config to enable/disable here.",
          { title = "NeoExtras" }
        )
        return
      end
      plug.enabled = not plug.enabled
      Config.json.data.extras = vim.tbl_filter(function(name)
        return name ~= plug.module
      end, Config.json.data.extras)
      M.state = vim.tbl_filter(function(name)
        return name ~= plug.module
      end, M.state)
      if plug.enabled then
        table.insert(Config.json.data.extras, plug.module)
        M.state[#M.state + 1] = plug.module
      end
      table.sort(Config.json.data.extras)
      Lonard.json.save()
      Lonard.info(
        "`"
          .. plug.name
          .. "`"
          .. " "
          .. (plug.enabled and "**enabled**" or "**disabled**")
          .. "\nPlease restart NeoVerse to apply the changes.",
        { title = "NeoExtras" }
      )
      self:update()
      return
    end
  end
end

function V:update()
  self.diag = {}
  self.extras = M.get()
  self.text = LazyText.new()
  self.text.padding = 2
  self:render()
  self.text:trim()
  vim.bo[self.float.buf].modifiable = true
  self.text:render(self.float.buf)
  vim.bo[self.float.buf].modifiable = false
  vim.diagnostic.set(
    M.ns,
    self.float.buf,
    ---@param diag LazyDiagnostic
    vim.tbl_map(function(diag)
      diag.col = 0
      diag.lnum = diag.row - 1
      return diag
    end, self.diag),
    { signs = false, virtual_text = true }
  )
end

function V:render()
  self.text:nl():nl():append("NeoVerse Extras", "LazyH1"):nl():nl()
  self.text
    :append("This is a list of all enabled/disabled NeoVerse extras.", "LazyComment")
    :nl()
    :append("Each extra shows the required and optional plugins it may install.", "LazyComment")
    :nl()
    :append("Enable/disable extras with the ", "LazyComment")
    :append("<x>", "LazySpecial")
    :append(" key", "LazyComment")
    :nl()
  for _, extra in ipairs(self.extras) do
    extra.section = nil
  end
  self:section({ enabled = true, title = "Enabled" })
  self:section({ recommended = true, include = "^lang%.", title = "Recommended Languages", empty = false })
  self:section({ recommended = true, title = "Recommended Plugins", empty = false })
  self:section({ title = "Plugins", exclude = "^lang%." })
  self:section({ title = "Languages" })
end

---@param extra NeoExtra
function V:extra(extra)
  if not extra.managed then
    self:diagnostic({
      message = "Not managed by NeoExtra (config)",
      severity = vim.diagnostic.severity.WARN,
    })
  end
  extra.row = self.text:row()
  local hl = extra.managed and "LazySpecial" or "LazyLocal"
  if extra.enabled then
    self.text:append("  " .. LazyConfig.options.ui.icons.loaded .. " ", hl)
  else
    self.text:append("  " .. LazyConfig.options.ui.icons.not_loaded .. " ", hl)
  end
  self.text:append(extra.name)
  if extra.recommended then
    self.text:append(" "):append(LazyConfig.options.ui.icons.favorite or " ", "LazyCommit")
  end
  if extra.source.name ~= "NeoVerse" then
    self.text:append(" "):append(LazyConfig.options.ui.icons.event .. " " .. extra.source.name, "LazyReasonEvent")
  end
  for _, plugin in ipairs(extra.plugins) do
    self.text:append(" "):append(LazyConfig.options.ui.icons.plugin .. "" .. plugin, "LazyReasonPlugin")
  end
  for _, plugin in ipairs(extra.optional) do
    self.text:append(" "):append(LazyConfig.options.ui.icons.plugin .. "" .. plugin, "LazyReasonRequire")
  end
  if extra.desc then
    self.text:nl():append("    " .. extra.desc, "LazyComment")
  end
  self.text:nl()
end

---@param opts {enabled?:boolean, title:string, recommended?:boolean, include?:string, exclude?:string, empty?:boolean}
function V:section(opts)
  opts = opts or {}
  ---@type NeoExtra[]
  local extras = vim.tbl_filter(function(extra)
    return extra.section == nil
      and (opts.enabled == nil or extra.enabled == opts.enabled)
      and (opts.recommended == nil or extra.recommended == opts.recommended)
      and (opts.include == nil or extra.name:find(opts.include))
      and (opts.exclude == nil or not extra.name:find(opts.exclude))
  end, self.extras)
  if opts.empty == false and #extras == 0 then
    return
  end
  self.text:nl():append(opts.title .. ":", "LazyH2"):append(" (" .. #extras .. ")", "LazyComment"):nl()
  for _, extra in ipairs(extras) do
    extra.section = opts.title
    self:extra(extra)
  end
end

function M.show()
  return V.new()
end

function M.setup()
  vim.api.nvim_create_user_command("NeoExtras", function()
    M.show()
  end, { desc = "Manage NeoVerse extras" })
end

return M
