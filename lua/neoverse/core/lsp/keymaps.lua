---@diagnostic disable: inject-field
local M = {}
local Utils = require("neoverse.utils")

---@type NeoKeysLspSpec[]|nil
M._keys = nil

M._loaded = false

---@alias NeoKeysLspSpec LazyKeysSpec|{has?:string}
---@alias NeoKeysLsp LazyKeys|{has?:string}

---@return NeoKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end
    -- stylua: ignore
    M._keys =  {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "code » lsp info" },
      { "gd", ":Telescope lsp_definitions reuse_win=true<cr>", desc = "code » definitions", has = "definition" },
      { "gT", ":Telescope lsp_type_definitions reuse_win=true<cr>", desc = "code » type definitions" },
      { "gI", ":Telescope lsp_implementations reuse_win=true<cr>", desc = "code » implementations" },
      { "gr", ":Telescope lsp_references reuse_win=true<cr>", desc = "code » references" },
      { "gD", vim.lsp.buf.declaration, desc = "code » declaration" },
      {
        "K",
        function()
          return Utils.call("ufo").peekFoldedLinesUnderCursor() or vim.lsp.buf.hover()
        end,
        desc = "Hover",
        has = "hover",
      },
      {
        "gK",
        vim.lsp.buf.signature_help,
        desc = "Code » Signature help",
        has = "signatureHelp",
      },
      {
        "<leader>ca",
        vim.lsp.buf.code_action,
        desc = "code » code action",
        mode = { "n", "v" },
        has = "codeAction"
      },
      {
        "<leader>cx",
        vim.diagnostic.open_float,
        desc = "code » diagnostic open float"
      },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = { "source" },
              diagnostics = {},
            },
          })
        end,
        desc = "code » source action",
        has = "codeAction",
      }
    }
  if Utils.lazy_has("inc-rename.nvim") then
    M._keys[#M._keys + 1] = {
      "<leader>cr",
      function()
        local inc_rename = require("inc_rename")
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
      end,
      desc = "code » rename under cursor",
      has = "rename",
      expr = true,
    }
  else
    M._keys[#M._keys + 1] = {
      "<leader>cr",
      vim.lsp.buf.rename,
      desc = "code » rename under cursor",
      has = "rename",
    }
  end
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = Utils.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = Utils.opts("nvim-lspconfig")
  local clients = Utils.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)
  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      opts.has = nil
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

function M.setup()
  if M._loaded then
    return
  end

  Utils.lsp.on_attach(function(client, buffer)
    M.on_attach(client, buffer)
  end)
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local buffer = vim.api.nvim_get_current_buf()
    M.on_attach(client, buffer)
    return ret
  end

  M._loaded = true
end

return M
