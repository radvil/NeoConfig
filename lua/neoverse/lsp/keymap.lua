---@diagnostic disable: inject-field

local M = {}

M._loaded = false

---@type PluginLspKeys
M._keys = nil

---@class NeoLspMappingOpts
local options = {
  enable_defaults = true,
  ---@type nil | fun(client, buffer)
  on_attach = nil,
}

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format_document = function()
    require("neoverse.lsp.format").format({ force = true })
  end
  if not M._keys then
    ---@class PluginLspKeys
    M._keys = {
      { "gd", ":Telescope lsp_definitions reuse_win=true<cr>", desc = "Definitions", has = "definition" },
      { "gT", ":Telescope lsp_type_definitions reuse_win=true<cr>", desc = "Type definitions" },
      { "gI", ":Telescope lsp_implementations reuse_win=true<cr>", desc = "Implementations" },
      { "gr", ":Telescope lsp_references reuse_win=true<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
      {
        "K",
        function()
          local ufo = require("neoverse.utils").call("ufo")
          if not ufo or not ufo.peekFoldedLinesUnderCursor() then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Hover",
        has = "hover",
      },
      {
        "gK",
        vim.lsp.buf.signature_help,
        desc = "Signature help",
        has = "signatureHelp",
      },
      { "<leader>cx", vim.diagnostic.open_float, desc = "Diagnostic open float" },
      {
        "<a-k>",
        vim.lsp.buf.signature_help,
        mode = "i",
        desc = "Signature Help",
        has = "signatureHelp",
      },
      { "]d", M.diagnostic_goto(true), desc = "Next diagnostic" },
      { "[d", M.diagnostic_goto(false), desc = "Prev diagnostic" },
      { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next error" },
      { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev error" },
      { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next warning" },
      { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev warning" },
      {
        "<leader>cf",
        format_document,
        desc = "Format document",
        has = "documentFormatting",
      },
      {
        "<leader>cf",
        format_document,
        has = "documentRangeFormatting",
        desc = "Format range",
        mode = "v",
      },
      {
        "<leader>ca",
        vim.lsp.buf.code_action,
        desc = "Code action",
        has = "codeAction",
        mode = { "n", "v" },
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
        desc = "Source action",
        has = "codeAction",
      },
    }
  end
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = require("neoverse.utils").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>
  local function add(keymap)
    local keys = Keys.parse(keymap)
    if keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end
  for _, keymap in ipairs(M.get()) do
    add(keymap)
  end
  local opts = require("neoverse.utils").opts("nvim-lspconfig")
  local clients = require("neoverse.utils").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
      add(keymap)
    end
  end
  return keymaps
end

function M.on_attach(client, buffer)
  if options.enable_defaults then
    local Keys = require("lazy.core.handler.keys")
    local keymaps = M.resolve(buffer)
    for _, keys in pairs(keymaps) do
      if not keys.has or M.has(buffer, keys.has) then
        local opts = Keys.opts(keys)
        opts.has = nil
        opts.silent = opts.silent ~= false
        opts.buffer = buffer
        vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
      end
    end
  end -- OEL enable_defaults
  if client.server_capabilities["documentSymbolProvider"] then
    if require("neoverse.utils").lazy_has("nvim-navic") then
      require("nvim-navic").attach(client, buffer)
    end
  end
  if client.server_capabilities.renameProvider then
    if require("neoverse.utils").lazy_has("inc-rename.nvim") then
      vim.keymap.set("n", "<leader>cr", function()
        return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
      end, {
        desc = "Rename under cursor",
        buffer = buffer,
        expr = true,
      })
    else
      vim.keymap.set("n", "<leader>cr", ":CR<cr>", {
        desc = "Rename under cursor",
        buffer = buffer,
      })
    end
  end
  if options.on_attach then
    options.on_attach(client, buffer)
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

---@param opts NeoLspMappingOpts
function M.setup(opts)
  if not M._loaded then
    options = vim.tbl_deep_extend("force", options, opts or {}) or options
    require("neoverse.utils").on_lsp_attach(M.on_attach)
    M._loaded = true
  end
end

return M
