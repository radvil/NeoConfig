local M = {}

local DEFAULT_SERVERS = {
  "angularls",
  "tsserver",
  "volar",
  "tailwindcss",
  "eslint",
  "pyright",
}

local bun_servers = nil

local function is_bun_server(name)
  for _, server in ipairs(bun_servers or DEFAULT_SERVERS) do
    if server == name then
      return true
    end
  end
  return false
end

local function is_bun_available()
  local bunx = vim.fn.executable("bun")
  if bunx == 0 then
    return false
  end
  return true
end

M.add_bun_prefix = function(config, _)
  if config.cmd and is_bun_available() and is_bun_server(config.name) then
    config.cmd = vim.list_extend({ "bun", "x" }, config.cmd)
  end
end

---Add bun for Node.js-based servers
---@param servers table<string>
M.setup = function(servers)
  bun_servers = servers
  local lspconfig_util = require("lspconfig.util")
  lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, M.add_bun_prefix)
end

return M
