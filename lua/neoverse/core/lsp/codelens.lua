---@diagnostic disable: missing-fields
local M = {}
---@param opts NeoLspCodeLensOpts
function M.setup(opts)
  local Utils = require("neoverse.utils")
  if opts.enabled and vim.lsp.codelens then
    Utils.lsp.on_attach(function(client, buffer)
      if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()
        --- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          callback = vim.lsp.codelens.refresh,
          buffer = buffer,
        })
      end
    end)
  end
end

return M
