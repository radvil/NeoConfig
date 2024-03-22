---@diagnostic disable: missing-fields
local M = {}
local inlay_hint = vim.lsp.inlay_hint

---@param opts NeoLspInlayHintsOpts
function M.setup(opts)
  Lonard.lsp.on_attach(function(client, buffer)
    if client.supports_method("textDocument/inlayHint") then
      inlay_hint.enable(buffer, opts.enabled)
      vim.keymap.set("n", "<leader>uh", function()
        if inlay_hint.is_enabled(buffer) then
          inlay_hint.enable(buffer, false)
          Lonard.warn("DISABLED", { title = "INLAY HINTS" })
        else
          inlay_hint.enable(buffer, true)
          Lonard.info("ENABLED", { title = "INLAY HINTS" })
        end
      end, { buffer = buffer, desc = "toggle » inlay hints" })
    end
  end)
end

return M
