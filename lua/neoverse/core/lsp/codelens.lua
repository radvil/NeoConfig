---@diagnostic disable: missing-fields
local M = {}
---@param opts NeoLspCodeLensOpts
function M.setup(opts)
  if opts.enabled and vim.lsp.codelens then
    Lonard.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end)
  end
end

return M
