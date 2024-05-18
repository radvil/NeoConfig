---@diagnostic disable: missing-fields, param-type-mismatch
---@class neoverse.utils.root
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m)
    return m.get()
  end,
})

---@class NeoRoot
---@field paths string[]
---@field spec NeoRootSpec
---@alias NeoRootFn fun(buf: number): (string|string[])
---@alias NeoRootSpec string|string[]|NeoRootFn
---@type NeoRootSpec[]
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

M.cache = {}

M.pretty_cache = {} ---@type table<string, string>

M.detectors = {}

function M.detectors.cwd()
  return { vim.uv.cwd() }
end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  for _, client in pairs(Lonard.lsp.get_clients({ bufnr = buf })) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
    if client.config.root_dir then
      roots[#roots + 1] = client.config.root_dir
    end
  end
  return vim.tbl_filter(function(path)
    path = Lonard.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
      if p:sub(1, 1) == "*" and name:find(p:sub(2) .. "$") then
        return true
      end
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

---@param spec NeoRootSpec
---@return NeoRootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

---@param opts? { buf?: number, spec?: NeoRootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.neo_root_spec) == "table" and vim.g.neo_root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type NeoRoot[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path
  return Lonard.norm(path)
end

function M.git()
  local root = M.get()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
  return ret
end

function M.pretty_path()
  local path = vim.fn.expand("%:p") --[[@as string]]
  if path == "" then
    return ""
  end
  path = Lonard.norm(path)
  if M.pretty_cache[path] then
    return M.pretty_cache[path]
  end
  local cache_key = path
  local cwd = M.realpath(vim.uv.cwd()) or ""
  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  else
    local roots = M.detect({ spec = { ".git" } })
    local root = roots[1] and roots[1].paths[1] or nil
    if root then
      path = path:sub(#vim.fs.dirname(root) + 2)
    end
  end
  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, "[\\/]")
  if #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end
  local ret = table.concat(parts, sep)
  M.pretty_cache[cache_key] = ret
  return ret
end

function M.info()
  local spec = type(vim.g.neo_root_spec) == "table" and vim.g.neo_root_spec or M.spec
  local roots = M.detect({ all = true })
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
        first and "x" or " ",
        path,
        ---@diagnostic disable-next-line: param-type-mismatch
        type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = "```lua"
  lines[#lines + 1] = "vim.g.neo_root_spec = " .. vim.inspect(spec)
  lines[#lines + 1] = "```"
  Lonard.info(lines, { title = "Neoverse Roots" })
  return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

function M.cwd()
  return M.realpath(vim.uv.cwd()) or ""
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean}
---@return string
function M.get(opts)
  local buf = vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false })
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  if opts and opts.normalize then
    return ret
  end
  return Lonard.is_win() and ret:gsub("/", "\\") or ret
end

function M.setup()
  vim.api.nvim_create_user_command("NeoRoot", function()
    Lonard.root.info()
  end, { desc = "Neoverse roots for the current buffer" })
  vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("neoverse_root_cache", { clear = true }),
    callback = function(event)
      M.cache[event.buf] = nil
    end,
  })
end

return M
