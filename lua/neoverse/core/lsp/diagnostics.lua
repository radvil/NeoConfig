local M = {}

---@param opts NeoLspDiagOpts
function M.setup(opts)
  local Config = require("neoverse.config")

  for name, icon in pairs(Config.icons.Diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  if type(opts.virtual_text) == "table" and opts.virtual_text.prefix == "icons" then
    opts.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
      or function(diagnostic)
        local icons = Config.icons.Diagnostics
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
      end
  end

  vim.diagnostic.config(vim.deepcopy(opts))
end

return M
