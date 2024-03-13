local M = {}

---@param name string
---@param cb function | string
---@param desc string
local cmd = function(name, cb, desc)
  return vim.api.nvim_create_user_command("C" .. name, cb, { desc = "LSP » " .. desc })
end

function M.setup()
  cmd("R", "lua vim.lsp.buf.rename()", "Rename under cursor")
  cmd("A", "lua vim.lsp.buf.code_action()", "Code action")
  cmd("D", "Telescope lsp_definitions", "Find definitions")
  cmd("V", vim.lsp.buf.signature_help, "Signature help")
  cmd("I", "Telescope lsp_implementations", "Find implementations")
  cmd("L", "Telescope lsp_references", "Find references")
  cmd("T", "Telescope lsp_type_definitions", "Find type defintions")
  cmd("L", vim.lsp.codelens.run, "Run Codelens")
  cmd("C", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
end

return M
