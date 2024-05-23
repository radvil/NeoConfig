---@diagnostic disable: missing-fields
local M = {}

---@param opts NeoLspInlayHintsOpts
function M.setup(opts)
  -- inlay hints
  if opts.enabled then
    Lonard.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
      if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
        Lonard.toggle.inlay_hints(buffer, true)
      end
    end)
  end
end

return M
