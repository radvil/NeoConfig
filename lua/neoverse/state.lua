---@class NeoState
local M = {}

---@type NeoState
local defaults = {
  smooth_cursor = true,
  barbecue = false,
  noice = true,
}

---@type NeoState | nil
local states = nil

setmetatable(M, {
  __index = function(_, key)
    if states == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast states NeoState
    return states[key]
  end,
})

return M
