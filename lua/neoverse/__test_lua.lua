---@diagnostic disable: param-type-mismatch

local function getcwd()
  vim.print(vim.fn.getcwd():gsub(os.getenv("HOME"), "~"))
end

local function is_bun_available()
  local bunx = vim.fn.executable("bunx")
  if bunx == 0 then
    return false
  end
  return true
end

if is_bun_available() then
  vim.print(vim.fn.exepath("bun"))
else
  vim.print("no")
end
