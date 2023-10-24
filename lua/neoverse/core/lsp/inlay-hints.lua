local M = {}

M.enabled = false

---@param opts NeoLspInlayHintsOpts
function M.setup(opts)
  M.enabled = opts.enabled
  local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  require("neoverse.utils").lsp.on_attach(function(client, buffer)
    if client.supports_method("textDocument/inlayHint") and inlay_hint then
      inlay_hint(buffer, M.enabled)
      vim.keymap.set("n", "<leader>uh", function()
        M.enabled = not M.enabled
        inlay_hint(buffer, M.enabled)
        vim.notify(
          "LSP » Inlay hint " .. (M.enabled and "enabled" or "disabled") .. string.format(" [%s]", buffer),
          vim.log.levels[M.enabled and "INFO" or "WARN"]
        )
      end, { buffer = buffer, desc = "Toggle » Inlay hints" })
    end
  end)
end

return M
