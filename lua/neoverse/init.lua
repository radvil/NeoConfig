local M = {}

---@param opts? NeoVerseOpts
function M.setup(opts)
  require("neoverse.config").bootstrap(opts)
end

return M
