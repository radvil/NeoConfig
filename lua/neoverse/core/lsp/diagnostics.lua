local M = {}

---@param opts NeoLspDiagOpts
function M.setup(opts)
  for severity, icon in pairs(opts.signs.text) do
    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  if type(opts.virtual_text) == "table" and opts.virtual_text.prefix == "icons" then
    opts.virtual_text.prefix = function(diagnostic)
      local icons = require("neoverse.config").icons.Diagnostics
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
    end
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.diagnostic.config(vim.deepcopy(opts))
end

return M
