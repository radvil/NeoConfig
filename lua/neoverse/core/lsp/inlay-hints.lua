---@diagnostic disable: missing-fields
local M = {}

---@param opts NeoLspInlayHintsOpts
function M.setup(opts)
  -- inlay hints
  if opts.enabled then
    Lonard.lsp.on_attach(function(client, buffer)
      if client.supports_method("textDocument/inlayHint") then
        Lonard.toggle.inlay_hints(buffer, true)
      end
    end)
  end
end

return M
